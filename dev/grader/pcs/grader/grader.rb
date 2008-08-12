require 'monitor'
require 'logger'
require 'fileutils'
require 'pcs/grader/storage'
require 'pcs/ext/process'
require 'pcs/checker_response'
require 'pcs/grader_response'
require 'pcs/utils'



module PCS
  module Grader



    #
    # The Grader class is the main class of the Grader Module. It is responsible
    # to test problems solutions. It recieves requests for testing through its
    # public method test. The class creates other needed modules as Storage, Cache
    # and Compiler
    #
    class Grader

      #
      # The constructor accepts as parameter the grader and storage configuration
      # objects. It creates the needed directory structure for grading and
      # instantiates the cache, storate and compiler modules.
      #
      def initialize(grader_config, storage_config)
        @lock = Monitor.new
        @is_grading = false
        @logger = nil
        @grader_config = grader_config

        create_directories()
        clear_directories()
        change_directory_permissions()

        @logger = Logger.new(grader_config.logger_filepath, grader_config.logger_shift_age, grader_config.logger_shift_size)
        @logger.level = grader_config.logging_level
        @logger.datetime_format = grader_config.logger_datetime_format

        @logger.info("Grader Initializing ...") if @logger

        @cache = Cache.new(@grader_config.cache_root, @logger)
        @compiler = Compiler.new(@grader_config.compiler_root, @logger)
        @storage = Storage.new(@grader_config, @cache, @compiler, storage_config, @logger)

        @logger.info("Grader Running") if @logger
        puts "Grader Running"
      end


      #
      # Creates the directory structure needed by the grader.
      #
      def create_directories
        Utils.create_directory(@grader_config.exec_root)
        Utils.create_directory(@grader_config.test_root)
        Utils.create_directory(@grader_config.logger_root)
      end

      private :create_directories

      def change_directory_permissions
        directories = [ @grader_config.sources_root,
                        @grader_config.lib_root,
                        @grader_config.test_root,
                      ]
        FileUtils.chmod(0777,directories)
      end

      private :change_directory_permissions


      #
      # Runs a single test specified by test_id on a solution with a submit_id,
      # using module specified by module_id. The problem constraints depends on
      # the problem_id parameter. The result is check with checker identified
      # by checker_id.
      #
      def test(problem_id, submit_id, test_id, checker_id, module_id)
        begin
          @lock.synchronize do
            if @is_grading
              # TODO: create GraderResponse object. It should contain the compiler
              # responses and the test response. The test response should not contain
              # the compiler responses.
              return 'Currently Grading. Try Again.'
            else
              @is_grading = true
            end
          end

          unless test_id.instance_of?(Array)
            test_id = [test_id]
          end

          @logger.info("Grader: Test request recieved for problem_id #{problem_id},\n" +
            "submit_id #{submit_id}, test_id #{test_id.join(" ")}, checker_id #{checker_id}, module_id #{module_id}") if @logger

          clear_directories
          grader_response = GraderResponse.new

          solution_compiler_response, checker_compiler_response = copy_files(submit_id, checker_id, module_id)

          @logger.info("Solution Compilation Message: #{solution_compiler_response.message}") if @logger
          @logger.info("Checker Compilation Message: #{checker_compiler_response.message}") if @logger

          grader_response.solution_compiler_response = solution_compiler_response
          grader_response.checker_compiler_response = checker_compiler_response

          if (solution_compiler_response.status != CompilerResponse::OK ||
              checker_compiler_response.status != CompilerResponse::OK)
              #?
              #TODO: Something
              #
          else

            test_id.each do |id|
              begin
                test_response = nil
                clear_test_directory
                copy_test(id)
                test_response = grade(problem_id) or nil
                test_response.test_id = id
              rescue
                @logger.error($!) if @logger
                raise
              ensure
                if ( test_response.nil? )
                  test_response = TestResponse.new
                  test_response.status = TestResponse::INTERNAL_ERROR
                  test_response.test_id = id;
                end
                grader_response.test_responses << test_response
              end
            end

          end

          return grader_response

        rescue
          raise
        ensure
          @lock.synchronize do
            @is_grading = false
          end

#          grader_response = GraderResponse.new
#
#          return grader_response
        end
      end


      def clear_directories
        Utils.clear_directory(@grader_config.exec_root)
        Utils.clear_directory(@grader_config.test_root)
      end


      def copy_files(submit_id, checker_id, module_id)
        solution_compiler_response = @storage.copy_solution(submit_id, module_id, @grader_config.exec_root)
        checker_compiler_response = @storage.copy_checker(checker_id, @grader_config.checker_filepath)

        return solution_compiler_response, checker_compiler_response
      end


      #
      # Delete all files in the test directory except the checker
      #
      def clear_test_directory
        files = Dir.glob(File.join(@grader_config.test_root, "*"))
        files.delete(@grader_config.checker_filepath)
        FileUtils.rm(files, :force => true)
      end


      def copy_test(test_id)
        @storage.copy_test(test_id, @grader_config.test_root)
      end


      def grade(problem_id)
        problem_info = @storage.get_problem_info(problem_id)
        test_response = execute(problem_info)

        return test_response
      end


      def check_answer

        cmd_line = File.join(@grader_config.checker_filepath) + " " + @grader_config.input_filepath + " " +
        @grader_config.output_filepath + " " + @grader_config.solution_filepath

        @logger.info("Checker Running with following command line: " + cmd_line) if @logger

        child_pid = Process.fork() do

          begin
            $stdout.reopen(@grader_config.checker_output_filepath, "w") or raise "Unable to redirect STDOUT"

            # Restricts CPU usage
            Process.setrlimit(Process::RLIMIT_CPU, GraderConfig::CHECKER_TIME_LIMIT / 1000 )
            # Restricts memory usage
            Process.setrlimit(Process::RLIMIT_AS, GraderConfig::CHECKER_MEMORY_LIMIT * 1024)
            # Restricts output file size
            Process.setrlimit(Process::RLIMIT_FSIZE, GraderConfig::CHECKER_OUTPUT_LIMIT * 1024)

            Dir.chdir(@grader_config.exec_root)
            # Dir.chroot(@grader_config.exec_root)
            # Process::Sys.setuid(@grader_config.execute_uid)

          rescue
            @logger.error($!) if @logger
            exit(-1)
          end

          exec(cmd_line)

        end

        status, resources_used = Process.wait4(child_pid)

        user_time = resources_used[:ru_utime_sec] * 1000 + resources_used[:ru_utime_usec] / 1000
        system_time = resources_used[:ru_stime_sec] * 1000 + resources_used[:ru_stime_usec]/ 1000

        @logger.info("Checker Execution Ended")
        @logger.info("User Time: #{user_time} System Time: #{system_time}")

        result = CheckerResponse.new

        begin
          checker_output = IO.read(@grader_config.checker_output_filepath).split("\n")
        rescue
          @logger.error("Error reading checker output:" +$!) if @logger
          raise
        end

        if (user_time > GraderConfig::CHECKER_TIME_LIMIT)
          result.status = CheckerResponse::TIME_LIMIT
          result.message = "Time Limit Exceeded"
        elsif (status.exitstatus != 0 ||
               checker_output[0].to_i == CheckerResponse::INTERNAL_ERROR ||
               status.termsig != nil)
          result.status = CheckerResponse::INTERNAL_ERROR
          result.message = checker_output[3] or "Internal error occured in checker"
        else
          raise "Checker output to short" if (checker_output.size<3)

          result.status = checker_output[0]
          result.correctness = checker_output[1]
          result.message = checker_output[2]
        end

        result.user_time = user_time
        result.system_time = system_time
        result.exit_status = status.exitstatus
        result.term_sig = status.termsig

        return result
      end


      def execute(problem_info)

        @logger.info("Execution Started for Problem #{problem_info.problem_id}") if @logger
        @logger.info("Limits: TL:#{problem_info.time_limit} ms") if @logger
        @logger.info("Memory L:#{problem_info.memory_limit} kb") if @logger
        @logger.info("Output L:#{problem_info.output_limit} kb") if @logger

        pid = Process.fork() do

          # Redirects STDIN, STDOUT, STDERR
          begin
            $stdin.reopen(@grader_config.input_filepath, "r") or raise "Unable to redirect STDIN"
            $stdout.reopen(@grader_config.output_filepath, "w") or raise "Unable to redirect STDOUT"
            $stderr.reopen(@grader_config.error_filepath, "w") or raise "Unable to redirect STDERR"

            # Restricts CPU usage
            Process.setrlimit(Process::RLIMIT_CPU, problem_info.time_limit / 1000)
            # Restricts memory usage
            Process.setrlimit(Process::RLIMIT_AS, problem_info.memory_limit * 1024)
            # Restricts output file size
            Process.setrlimit(Process::RLIMIT_FSIZE, problem_info.output_limit * 1024)

            Dir.chdir(@grader_config.exec_root)
            # Dir.chroot(@grader_config.exec_root)
            # Process::Sys.setuid(@grader_config.execute_uid)

          rescue
            @logger.error($!)
            exit(-1)
          end

          exec File.join('.', @grader_config.exec_filename)

        end

        status, resources_used = Process.wait4(pid)

        user_time = resources_used[:ru_utime_sec] * 1000 + resources_used[:ru_utime_usec] / 1000
        system_time = resources_used[:ru_stime_sec] * 1000 + resources_used[:ru_stime_usec] / 1000

        @logger.info("Execution Ended") if @logger
        @logger.info("User Time: #{user_time} System Time: #{system_time}") if @logger

        #
        # Creating a TestResponse object and filling it acording to the time
        # the child process has run, and the signal that caused it to stop
        #
        result = TestResponse.new

        if ( user_time > problem_info.time_limit )
          result.status = TestResponse::TIME_LIMIT
          result.message = "Time Limit Exceeded"
        elsif ( status.termsig == Signal.list["SEGV"] )
          result.status = TestResponse::SEGMENTATION_FAULT
          result.message = "Segmentation Fault (Invalid Memory Reference)"
        elsif ( status.termsig == Signal.list["XFSZ"] )
          result.status = TestResponse::EXCEESIVE_OUTPUT
          result.message = "Exceesive Output"
        elsif ( status.termsig == Signal.list["KILL"] )
          result.status = TestResponse::KILL_SIGNAL
          result.message = "Received KILL Signal"
        elsif ( status.termsig == nil )
          result.status = TestResponse::OK
          result.message = "OK"

          result.checker_response = check_answer()
        else
          result.status = TestResponse::EXECUTION_ERROR
          result.message = "Execution Error"
        end

        result.user_time = user_time
        result.system_time = system_time
        result.memory_usage = 0
        result.exit_status = status.exitstatus
        result.term_sig = status.termsig

        @logger.info("Execution Status: #{result.status}:#{result.message}") if @logger
        @logger.info("Exit Status:#{result.exit_status}") if @logger
        @logger.info("Terminal Signal:#{result.term_sig}") if @logger

        return result
      end


      private :copy_files, :clear_directories, :grade, :execute, :check_answer

    end



  end
end
