require 'logger'
require 'rubygems'
gem 'activerecord'
require 'active_record'
require 'pcs/utils'
require 'pcs/grading_queue/queue'
require 'pcs/grading_queue/grader_agent'
require 'pcs/grading_queue/job'
require 'pcs/model/grader_response'
require 'pcs/model/compiler_response'
require 'pcs/model/submit'
require 'pcs/model/module'
require 'pcs/model/checker'
require 'soap/rpc/driver'

module PCS
  module GradingQueue
    
    
    
    class GradingQueue
      
      def initialize(grading_queue_config)
        @grading_queue_config = grading_queue_config
        @general_queue = Queue.new
        @monitor = Monitor.new
        @cond_var = @monitor.new_cond
        @graders = {}
        @counter = 1
        @logger = nil
        
        # Creating Logger
        Utils.create_directory(@grading_queue_config.logger_root)
        
        @logger = Logger.new(grading_queue_config.logger_filepath, grading_queue_config.logger_shift_age, grading_queue_config.logger_shift_size)
        @logger.level = grading_queue_config.logging_level
        @logger.datetime_format = grading_queue_config.logger_datetime_format
        
        @logger.info("GradingQueue initialize...") if @logger
        
        # DataBase Connection
        begin
          ActiveRecord::Base.allow_concurrency = true
          ActiveRecord::Base.establish_connection(@grading_queue_config.db_settings) or 
          raise 'DataBase Connection Error'
        rescue
          message = "GQ: DataBase Connection Error: #{$!.message}"
          @logger.error(message) if @logger
          raise message
        end
        
        @logger.info("GQ: Connection with DB established") if @logger
        @logger.info("GQ: GraderQueue Running") if @logger
        
        puts "GraderQueue Running"
      end
      
      # TODO: Add general jobs to grader Queue
      def add_grader(grader_address, grader_port)
        puts grader_address, grader_port
        @monitor.synchronize do
          begin
            message = "Adding new grader at #{grader_address}:#{grader_port} with id #{@counter}"
            @logger.info(message) if @logger
            @graders[@counter] = GraderAgent.new(@grading_queue_config, grader_address, grader_port, self)
            
            new_grader = @graders[@counter]
            
            @general_queue.get_all_jobs.each do |job|
              if (job.grader_id == Job::NO_GRADER)
                new_grader.add_job(job)
              end
            end
            
            @counter += 1
            return @counter - 1          
          rescue
            message = "Error adding the new grader at #{grader_address}:#{grader_port}, error: #{$!.message}"
            @logger.error(message + $!.backtrace.join("\n"))
            raise message
          end
        end
      end
      
      
      def get_graders()
        @monitor.synchronize do
          begin
            grader_ids = []
            @graders.each_key do |grader_key|
              grader_ids << grader_key
            end
            return grader_ids
          rescue
            message = "Error getting all graders, error: #{$!.message}"
            @logger.error(message + $!.backtrace.join("\n"))
            raise message
          end
        end      
      end
      
      
      def delete_grader(grader_id)
        #        grader_id = grader_id.to_i
        @monitor.synchronize do
          message = "Atempt to delete grader with id #{grader_id} #{grader_id.class}"
          @logger.info(message) if @logger
          
          if (@graders[grader_id].nil?)
            raise "GQ: Cannot delete grader with id #{grader_id}, no such grader exists"
          end
          if (@graders[grader_id].stop(Thread.current) == true)
            @cond_var.wait
            
            #
            # Re-assignes the jobs of the dying grader
            #
            jobs_to_reassign = @graders[grader_id].get_jobs
            @graders.delete(grader_id)
            message = "Reassigning #{jobs_to_reassign.size} jobs."
            @logger.info(message) if @logger
            jobs_to_reassign.each do |job|
              if (job.grader_id == Job::NO_GRADER)
                unless (@general_queue.include?(job))
                  @general_queue.push(job)
                end
              else
                job.grader_id = Job::NO_GRADER
                add_general_job(job)
              end            
            end
          else
            raise "GQ: Grader is already in stoping state"
          end
        end
      end
      
      
      def test(grader_id, problem_id, submit_id, test_id, checker_id, module_id)
        job = PCS::GradingQueue::Job.new(grader_id, problem_id, submit_id, test_id, checker_id, module_id)
        
        @monitor.synchronize do
          grader_response = PCS::Model::GraderResponse.new
          compiler_response1 = PCS::Model::CompilerResponse.new
          compiler_response1.save!
          compiler_response2 = PCS::Model::CompilerResponse.new
          compiler_response2.save!        
          grader_response.solution_compiler_response = compiler_response1
          grader_response.checker_compiler_response = compiler_response2
          # TODO: Optimize the following for less quaries.
          grader_response.status = PCS::Model::GraderResponse::IN_QUEUE
          grader_response.submit = PCS::Model::Submit.find(job.submit_id)
          grader_response.modul = PCS::Model::Module.find(job.module_id) if job.module_id
          grader_response.checker = PCS::Model::Checker.find(job.checker_id)
          grader_response.save!
          job.id = grader_response.grader_response_id
        end
        
        if (job.grader_id != Job::NO_GRADER)
          if (@graders[job.grader_id].nil?)
            raise "GQ: Unable to process job, no grader with id #{grader_id}"
          else
            @graders[job.grader_id].add_job(job)
            puts "Adding job with id #{job.id} to queue of grader #{job.grader_id}" 
          end
        else
          add_general_job(job)
          puts "Adding job with id #{job.id} to general queue"
        end
        return job.id
      end
      
      
      def add_general_job(job)
        @monitor.synchronize do
          @general_queue.push(job)
          @graders.each_value do |grader|
            grader.add_job(job)
          end
        end
      end
      
      
      def remove_top(id)
        @monitor.synchronize do
          job = @general_queue.top()
          if (job.id == id)
            @general_queue.pop()
            return true
          end
          return false
        end
      end
      
    end
    
    
    
  end
end
