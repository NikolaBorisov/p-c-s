require 'monitor'
require 'pcs/grader_response.rb'
require 'pcs/model/grader_response'
require 'pcs/model/test_response'
require 'pcs/model/test'
require 'pcs/model/submit'
require 'pcs/model/task'
require 'soap/rpc/driver'

module PCS
  module GradingQueue
    
    
    
    class GraderAgent
      
      # Constants about the @status of the GraderAgent
      NOT_RUNNING = 0
      STOPING = 1
      STARTING = 2
      RUNNING = 3
      WAITING = 4
      
      def initialize(grading_queue_config, grader_address, grader_port, grading_queue, logger = nil)
        @status = STARTING
        @queue = Queue.new
        @monitor = Monitor.new
        @cond_var = @monitor.new_cond
        @grading_queue = grading_queue
        @grading_queue_config = grading_queue_config
        @logger = logger
        puts "Initializing GQ"
        @thread = Thread.new { thread_loop }
        @thread.abort_on_exception = false
        puts "Starting the new Thread"
        
        
        #
        # Establishing a connection with Grader
        #
        times_to_retry = @grading_queue_config.times_to_retry
        while (times_to_retry > 0)
          begin
            # TODO: Anew, kwo da prawq s tozi namespace da go ostawq li taka (hard code-nat)?
            @grader = SOAP::RPC::Driver.new(grader_address + ":" + grader_port, 'urn:PCS/Grader')
            @grader.add_method('test', 'problem_id', 'submit_id', 'test_id', 'checker_id', 'module_id')
            break
          rescue
            times_to_retry -= 1
            if (times_to_retry > 0)
              sleep(@grading_queue_config.sleep_on_retry)
            else
              message = "GQ: Error connecting to Grader WS, error: ${$!.message}"
              @logger.error(message) if @logger
              raise message
            end
          end
        end        
      end
      
      
      #
      # Tries to stop the grader, by changing its @status to STOPING, returnes false if
      # the @status is already set to STOPING, or NOT_RUNNING
      #      
      def stop(thread)
        @monitor.synchronize do
          message = "GQ GA: Received stop command for grader with status #{@status}, trying to changing it to STOPING"
          @logger.info(message) if @logger
          if (@status == STOPING || @status == NOT_RUNNING)
            return false
          elsif (@status == WAITING)
            @status = STOPING
            @thread_to_notify_when_stoped = thread
            @thread.wakeup
            return true
          else
            @status = STOPING
            @thread_to_notify_when_stoped = thread
            return true
          end
        end
      end
      
      
      #
      # This is the function executed by the Thread of the grader. For each job
      # one circle is made, if the @queue is empty, then the Thread sleeps until
      # job is received.
      #      
      def thread_loop
        puts "I AM the NEW Thread"

        # DataBase Connection
        begin
          ActiveRecord::Base.establish_connection(@grading_queue_config.db_settings) or 
          raise 'DataBase Connection Error'
        rescue
          message = "GQ: DataBase Connection Error: #{$!.message}"
          @logger.error(message) if @logger
          raise message
        end
        puts "DataBase Connection Estalished"
        @logger.info("GQ: Connection with DB established") if @logger

        
        @status = RUNNING
        while (true)
          begin
            cur_job = nil
            # Waking up the thread that requested the STOP and killing the Thread of the Grader
            if (@status == STOPING)
              message = "Thread Stoped. Waiking the mother thread"
              @logger.info(message) if @logger
              # TODO: Decide about this sleep. It is needed to wait the thread that requested 
              # the sleep to fall asleap in order to wake him up.
              sleep(1)
              @thread_to_notify_when_stoped.wakeup
              @thread.exit
            end
            
            # Waits here until job in queue is added. It is notified by add_job function.
            # If while WAITING received a Stop request it is waked, skips to the top.
            if (@queue.empty?)
              message = "Queue is empty. Sleeping until waked up"
              @logger.info(message) if @logger
              @status = WAITING
              #@cond_var.wait
              Thread.stop
              
              # Skips to the top and dies
              next if (@status == STOPING) 
              @status = RUNNING
              message = "Waked up to start grading"
              @logger.info(message) if @logger
            end                
            
            message = "Queue has #{@queue.size} jobs. "
            top_job = @queue.pop()
            message += "Poping job from the top of the queue with id #{top_job.id}."
            @logger.info(message) if @logger
            if (top_job.grader_id == Job::NO_GRADER)
              if (@grading_queue.remove_top(top_job.id) == true)
                cur_job = top_job
              else
                cur_job = nil
              end
            else
              cur_job = top_job
            end
            
            if (!cur_job.nil?)
              message = "Fetching from DB the GraderResponse object with id {cur_job.id}"
              @logger.info(message) if @logger
              @monitor.synchronize do
                db_grader_response = PCS::Model::GraderResponse.find(cur_job.id)
                db_grader_response.status = PCS::Model::GraderResponse::GRADING
                db_grader_response.save!
              end
              
              message = "Sending request to grader with\n problem_id #{cur_job.problem_id}\n" +
                "submit_id #{cur_job.submit_id}\n test_id #{cur_job.test_id}\n" +
                "module_id #{cur_job.module_id}\n checker_id #{cur_job.checker_id}\n"
              @logger.info(message) if @logger
              grader_response = @grader.test(
                                             cur_job.problem_id, 
                                             cur_job.submit_id, 
                                             cur_job.test_id, 
                                             cur_job.checker_id, 
                                             cur_job.module_id
              )
              # Filling the DB
              puts "LOOK HERE", grader_response
              @monitor.synchronize do
                db_grader_response = PCS::Model::GraderResponse.find(cur_job.id)
                db_grader_response.fill_with(grader_response)
                db_grader_response.solution_compiler_response.save!
                db_grader_response.checker_compiler_response.save!
                db_grader_response.status = PCS::Model::GraderResponse::READY
                db_grader_response.save!
                
                if ( db_grader_response.test_responses.size == PCS::Model::Task.find(cur_job.problem_id).tests.size )
                  submit = PCS::Model::Submit.find(cur_job.submit_id)
                  submit.last_full_grader_response_id = db_grader_response.id
                  submit.save!
                end
              end
            end
            
          rescue
            message = $!.message + "\n" + $!.backtrace.join("\n")
            puts message
            @logger.error(message) if @logger
            raise
          end
          
        end
        
      end
      
      
      #
      # Adds Job to the Queue of the this GraderAgent. It also wakes up the Thread if 
      # fallen asleap.
      #
      def add_job(job)
        @monitor.synchronize do
          puts "ADDING JOB"
          @queue.push(job)
          puts @queue.size
          message = "Job with id #{job.id} added to queue of grader, waking this grader's thread..."
          @logger.info(message) if @logger
          puts "TUKA SAM"
          @thread.wakeup
        end
      end
      
      
      #
      # Return an Array of jobs from the GraderAgent queue.
      #
      def get_jobs()
        @monitor.synchronize do
          return @queue.get_all_jobs
        end
      end      
      
    end
    
    
    
  end
end