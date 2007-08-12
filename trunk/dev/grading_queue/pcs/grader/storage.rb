require 'pcs/grader/compiler'
require 'pcs/grader/cache'
require 'pcs/problem_info'
require 'pcs/compiler_option'
require 'pcs/test_response'
require 'pcs/compiler_response'
require 'pcs/utils'
require 'pcs/file_description'
require 'soap/rpc/driver'

module PCS
  module Grader
    
    
    
    class Storage
      
      def initialize(grader_config, cache, compiler, storage_config, logger = nil)
        @grader_config = grader_config
        @cache = cache
        @compiler = compiler
        @logger = logger
        @storage_config = storage_config
        
        @logger.info("Storage: Trying to connect to the Data Storage Server WebService at #{storage_config.host}.") if @logger
        
        times_to_retry = @storage_config.times_to_retry

        
        while (times_to_retry > 0)
          begin
            @storage_server = SOAP::RPC::Driver.new(storage_config.host, storage_config.namespace)
            
            @storage_server.add_method('get_submit_files', 'submit_id')
            @storage_server.add_method('get_test_files', 'test_id')
            @storage_server.add_method('get_module_files', 'module_id')
            @storage_server.add_method('get_checker_files', 'checker_id')
            @storage_server.add_method('get_problem_info', 'problem_id')
            @storage_server.add_method('get_compiler_options', 'submit_id')
            @storage_server.add_method('get_checker_compiler_options', 'checker_id')
            @storage_server.add_method('copy_file_to', 'file_id',  'user', 'ip', 'destination', 'port')
            
            break
          rescue
            times_to_retry -= 1
            if (times_to_retry > 0)
              sleep(@storage_config.sleep_on_retry)
            else
              message = "Storage: Error connecting to the Data Storage Server WS, error: ${$!.message}"
              @logger.error(message) if @logger
              raise message
            end
          end
        end
        
      end
      
      
      def create_directory
        Utils.create_directory(@grader_config.storage_root)
        Utils.create_directory(@grader_config.sources_root)
        Utils.create_directory(@grader_config.lib_root)
      end
      
      
      def clear_directory
        Utils.clear_directory(@grader_config.sources_root)
        Utils.clear_directory(@grader_config.lib_root)
        Utils.clear_directory(@grader_config.storage_root)
      end
      
      #
      # Creates and clears the Storage directory. If the directory exist then it
      # is just cleaned.
      #
      def create_clear_directory
        begin
          create_directory
          clear_directory
        rescue
          message = "Storage: #{$!.message}"
          @logger.error(message) if @logger
          raise message
        end        
      end

      private :create_directory, :clear_directory, :create_clear_directory
      #
      # Gets the ProblemInfo object from the DSS for given problem_id.
      # 
      def get_problem_info(problem_id)
        times_to_retry = @storage_config.times_to_retry
        while (times_to_retry > 0)
          begin
            problem_info = @storage_server.get_problem_info(problem_id)
            
            return problem_info
          rescue
            times_to_retry -= 1
            if times_to_retry > 0
              sleep(@storage_config.sleep_on_retry)
            else
              message = "Storage: Unable to get problem info for problem_id #{problem_id}, error: #{$!.message}"
              @logger.error(message) if @logger
              raise message
            end
          end
        end
      end
      
      
      #
      # Gets an array of file description objects from DSS for the submit files accociated with submit_id.
      # 
      def get_submit_files(submit_id)
        times_to_retry = @storage_config.times_to_retry
        while (times_to_retry > 0)
          begin          
            submit_files = @storage_server.get_submit_files(submit_id)
            return submit_files
          rescue            
            times_to_retry -= 1
            if (times_to_retry > 0)
              sleep(@storage_config.sleep_on_retry)
            else
              message = "Storage: Unable to get submit files from DSS, submit_id #{submit_id}, error: #{$!.message}"
              @logger.error(message) if @logger
              raise message
            end            
          end
        end       
      end
      
      #
      # Getting the module files form the DSS.
      # 
      def get_module_files(module_id)
        times_to_retry = @storage_config.times_to_retry
        while (times_to_retry > 0)
          begin          
            module_files = @storage_server.get_module_files(module_id)
            return module_files
          rescue            
            times_to_retry -= 1
            if (times_to_retry > 0)
              sleep(@storage_config.sleep_on_retry)
            else
              message = "Storage: Unable to get module files from DSS, module_id #{module_id}, error: #{$!.message}"
              @logger.error(message) if @logger
              raise message
            end            
          end
        end        
      end
      
      #
      # Getting the checker files form the DSS.
      # 
      def get_checker_files(checker_id)
        times_to_retry = @storage_config.times_to_retry
        while (times_to_retry > 0)
          begin
            checker_files = @storage_server.get_checker_files(checker_id)
            return checker_files
          rescue            
            times_to_retry -= 1
            if (times_to_retry > 0)
              sleep(@storage_config.sleep_on_retry)
            else
              message = "Storage: Unable to get checker files from DSS, checker_id #{checker_id}, error: #{$!.message}" + $!.backtrace.join("\n")
              @logger.error(message) if @logger
              raise message
            end
          end
        end        
      end
      
      #
      # Getting the test files form the DSS.
      #
      def get_test_files(test_id)
        times_to_retry = @storage_config.times_to_retry
        while (times_to_retry > 0)
          begin
            test_files = @storage_server.get_test_files(test_id)
            return test_files
          rescue            
            times_to_retry -= 1
            if (times_to_retry > 0)
              sleep(@storage_config.sleep_on_retry)
            else
              message = "Storage: Unable to get test files from DSS, test_id #{test_id}, error: #{$!.message}"
              @logger.error(message) if @logger
              raise message
            end
          end
        end
      end
      
      #
      # Getting the compiler options from the DSS.
      #
      def get_compiler_options(submit_id)
        times_to_retry = @storage_config.times_to_retry
        while (times_to_retry > 0)
          begin
            compiler_options = @storage_server.get_compiler_options(submit_id)
            return compiler_options
          rescue
            times_to_retry -= 1
            if (times_to_retry > 0)
              sleep(@storage_config.sleep_on_retry)
            else
              message = "Storage: Unable to get the compiler options for #{submit_id} from DSS, error: #{$!.message}"
              @logger.error(message) if @logger
              raise message
            end
          end
        end
      end
      
      #
      # Getting the compiler options for the checker from the DSS.
      #
      def get_checker_compiler_options(checker_id)
        times_to_retry = @storage_config.times_to_retry
        while (times_to_retry > 0)
          begin
            compiler_options = @storage_server.get_checker_compiler_options(checker_id)
            return compiler_options
          rescue
            times_to_retry -= 1
            if (times_to_retry > 0)
              sleep(@storage_config.sleep_on_retry)
            else
              message = "Storage: Unable to get the checker compiler options for #{checker_id} from DSS, error: #{$!.message}"
              @logger.error(message) if @logger
              raise message
            end
          end
        end
      end      
      
      
      #
      # This method given a Array of FileDescription objects copies the files
      # to the desired destinations. This function also return an string with
      # the full path to all source files in files, divided by spaces.
      #
      def get_files(files)
        sources = []
        
        files.each do |file|
          if (file.type == FileDescription::SOURCE)
            local_dest = File.join(@grader_config.sources_root, file.name)
            sources << local_dest
          elsif (file.type == FileDescription::MODULE)
            local_dest = File.join(@grader_config.lib_root, file.name)
            sources << local_dest
          elsif (file.type == FileDescription::HEADER)
            local_dest = File.join(@grader_config.lib_root, file.name)
          elsif (file.type == FileDescription::INPUT)
            local_dest = @grader_config.input_filepath
          elsif (file.type == FileDescription::SOLUTION)
            local_dest = @grader_config.solution_filepath
          elsif (file.type == FileDescription::CHECKER)
            local_dest = File.join(@grader_config.sources_root, file.name)
            sources << local_dest
          else
            message = "Storage: Unexpected file type #{file.type}"
            @logger.error(message) if @logger
            raise message
          end
          
          if (@cache.cached?(file.file_id))
            @cache.copy_file(file.file_id, local_dest)
          else
            times_to_retry = @storage_config.times_to_retry
            while (times_to_retry > 0)
              begin
                @storage_server.copy_file_to(file.file_id, @grader_config.user , @grader_config.grader_address, local_dest, @grader_config.grader_ssh_port)
                raise "Storage: Copy file from DSS failed, local file does not exist." unless File.exist?(local_dest)
                @cache.save_file(file.file_id, local_dest)
                break;
              rescue
                puts times_to_retry
                times_to_retry -= 1
                if (times_to_retry > 0)
                  sleep(@storage_config.sleep_on_retry)
                else
                  message = "Storage: Unable to get file with id #{file.file_id} from DSS and store it to #{local_dest}, error: #{$!.message}"
                  @logger.error(message) if @logger
                  raise message
                end
              end
            end
          end
        end
        
        return sources.join(" ")
      end
      
      
      def copy_solution(submit_id, module_id, destination)
        create_clear_directory
        
        submit_files = get_submit_files(submit_id)
        module_files = get_module_files(module_id)
        
        sources = get_files(submit_files + module_files)
        compiler_options = get_compiler_options(submit_id)
        
        #
        # Later when more language support is needed following lines must be changed
        #
        destination_file_name = File.join(destination, @grader_config.exec_filename)
        include_path = @grader_config.lib_root
        
        compiler_response = @compiler.compile(sources, destination_file_name, include_path, compiler_options)
        
        return compiler_response
      end
      
      
      def copy_checker(checker_id, destination)
        create_clear_directory
        
        checker_files = get_checker_files(checker_id)
        sources = get_files(checker_files)
        compiler_option = get_checker_compiler_options(checker_id)
        
        compiler_response = @compiler.compile(sources, destination, ".", compiler_option)
        
        return compiler_response
      end
      
      
      def copy_test(test_id, destination)
        create_clear_directory        
        test_files = get_test_files(test_id)        
        get_files(test_files)
        return true
      end
      
      
    end
    
    
    
  end
end
