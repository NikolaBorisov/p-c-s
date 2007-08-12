require 'logger'
require 'rubygems'
gem 'activerecord'
require 'active_record'
require 'pcs/file_description'
require 'pcs/utils'
require 'pcs/compiler_option'
require 'pcs/problem_info'
require 'pcs/model/submit'
require 'pcs/model/test'
require 'pcs/model/file'
require 'pcs/model/test_file'
require 'pcs/model/module'
require 'pcs/model/checker'
require 'pcs/model/task'
require 'pcs/model/restriction'
require 'pcs/model/program_language'
require 'pcs/model/compiler_option'


module PCS
  module Storage
    
    
    
    class Storage
      
      def initialize(storage_config)
        @storage_config = storage_config
        @logger = nil

        # Creating Logger
        Utils.create_directory(@storage_config.logger_root)
        
        @logger = Logger.new(storage_config.logger_filepath, storage_config.logger_shift_age, storage_config.logger_shift_size)
        @logger.level = storage_config.logging_level
        @logger.datetime_format = storage_config.logger_datetime_format

        @logger.info("Storage initialize") if @logger
        @logger.info("Storage running in directory:" + storage_config.storage_root) if @logger
        
        begin
          if (storage_config.file_server_location == '')
            Utils.create_directory(storage_config.files_storage_root)
          else
            Utils.create_remote_directory(storage_config.file_server_location, 
              storage_config.files_storage_root)
          end
        rescue
          message = "Unable to create storage dir, error: #{$!.message}"
          @logger.error(message) if @logger
          raise message
        end
        
        # DataBase Connection
        begin
          ActiveRecord::Base.establish_connection(@storage_config.db_settings) or 
          raise 'DataBase Connection Error'
        rescue
          message = "DSS: DataBase Connection Error: #{$!.message}"
          @logger.error(message) if @logger
          raise message
        end
        
        @logger.info("DSS: Connection with DB established") if @logger
        @logger.info("Storage")
        puts "Storage Running"
        
      end
      
      
      def get_submit_files(submit_id)
        begin
          submit = PCS::Model::Submit.find(submit_id)
          file_description = FileDescription.new(submit.file.name, submit.file.id, FileDescription::SOURCE)
          return [file_description]
        rescue
          message = "DSS: Unable to get submit files for submit_id #{submit_id}, error: #{$!}"
          @logger.error(message) if @logger
          raise message
        end
      end
      

      def get_test_files(test_id)
        begin
          test = PCS::Model::Test.find(test_id)
          file_descriptions = []
          
          test.tests_files.each do |test_file|
            file = test_file.file
            if ( test_file.test_type.to_i == FileDescription::INPUT )
              file_descriptions << FileDescription.new(file.name, file.id, FileDescription::INPUT)          
            elsif ( test_file.test_type.to_i == FileDescription::SOLUTION )
              file_descriptions << FileDescription.new(file.name, file.id, FileDescription::SOLUTION)          
            else
              raise "DSS: Unexpected test_type = #{test_file.test_type}," +
                " expected #{FileDescription::INPUT} or #{FileDescription::SOLUTION}"
            end
            
          end
          
          return file_descriptions
        rescue
          message = "DSS: Unable to get test files for test_id #{test_id}, error: #{$!.message}"
          @logger.error(message) if @logger
          raise message
        end
      end
      
      
      def get_module_files(module_id)
        begin
          if (module_id.nil?)
            return []
          end
          
          modul = PCS::Model::Module.find(module_id)
          file_descriptions = []
          
          modul.modules_files.each do |module_file|
            file = module_file.file
            if (module_file.module_type.to_i == FileDescription::MODULE)
              file_descriptions << FileDescription.new(file.name, file.id, FileDescription::MODULE)
            elsif (module_file.module_type.to_i == FileDescription::HEADER)
              file_descriptions << FileDescription.new(file.name, file.id, FileDescription::HEADER)          
            else
              raise "DSS: Unexpected module_type = #{module_file.module_type}," +
                " expected #{FileDescription::MODULE} or #{FileDescription::HEADER}"
            end            
          end
          
          return file_descriptions
        rescue
          message = "Unable to get module files for module_id #{module_id}, error: #{$!.message}"
          @logger.error(message) if @logger
          raise message
        end
      end
      
      
      def get_checker_files(checker_id)
        begin
          checker = PCS::Model::Checker.find(checker_id)
          file_description = FileDescription.new(checker.file.name, checker.file.id, FileDescription::CHECKER)
          return [file_description]
        rescue
          message = "DSS: Error getting checker files for checker_id #{checker_id}, error: #{$!.message}"
          @logger.error(message) if @logger
          raise message
        end
      end
      
      
      def get_problem_info(problem_id)
        begin
          task = PCS::Model::Task.find(problem_id)
          restriction = task.restrictions[0]
          problem_info = ProblemInfo.new
          problem_info.problem_id = problem_id
          problem_info.time_limit = restriction.runtime
          problem_info.memory_limit = restriction.memory
          problem_info.output_limit = restriction.output_size
          return problem_info
        rescue
          message = "DSS: Error getting problem info for problem_id #{problem_id}, error: #{$!.message}"
          @logger.error(message) if @logger
          raise message
        end
      end
      
      
      def get_compiler_options(submit_id)
        submit = PCS::Model::Submit.find(submit_id)
        program_language = submit.program_language
        compiler_option = program_language.compiler_options[0]

        # TODO: consider reimplementation using the constructor of CompilerOption
        co = CompilerOption.new
        co.command_line = compiler_option.command_line
        co.time_limit = compiler_option.time_limit
        
        return co
      end
   
      
      def get_checker_compiler_options(checker_id)
        checker = PCS::Model::Checker.find(checker_id)
        program_language = checker.program_language
        compiler_option = program_language.compiler_options[0]

        # TODO: consider reimplementation using the constructor of CompilerOption
        co = CompilerOption.new
        co.command_line = compiler_option.command_line
        co.time_limit = compiler_option.time_limit
        
        return co
      end
      
            
      def copy_file_to(file_id, user, ip, destination, port )
        times_to_retry = @storage_config.times_to_retry
        while (times_to_retry > 0)
          begin      
            source = File.join(@storage_config.files_storage_root_full_path, Utils.fileid2name(file_id))
		
            cmd_line = "scp -P #{port} #{source} #{user}@#{ip}:#{destination}"            
            @logger.info("DSS: Copy file :#{cmd_line}")
            if ( system(cmd_line) == false )
              message = "DSS: Transaction faild with error #{$?}"
              raise message
            else
              @logger.info("DSS: Copy Successful") if @logger
              return true
            end
          rescue
            times_to_retry -= 1
            if (times_to_retry > 0)
              sleep(@storage_config.sleep_on_retry)
            else
              message = "DSS: Unable to copy file with file_id #{file_id} and source #{source} to #{destination}, error: #{$!.message}"
              @logger.error(message) if @logger
              raise message
            end
          end
        end
      end
      
      
      #
      # Adds file to the File Server given a :
      # file_id where to store it,
      # and the file indentified by user@ip:source
      #
      # TODO: This method is untested.
      def add_file(file_id, user, ip, source, port)
        times_to_retry = @storage_config.times_to_retry
        while (times_to_retry > 0)
          begin
            destination = File.join(@storage_config.files_storage_root_full_path, Utils.fileid2name(file_id))
            cmd_line = "scp -P #{port} #{user}@#{ip}:#{source} #{destination}"
                        
            @logger.info("DSS: Saving file :#{cmd_line}")
            if ( system(cmd_line) == false )
              message = "DSS: Transaction faild with error #{$?}"
              raise message
            else
              @logger.info("DSS: Save Successful")
              return true;
            end            
          rescue        
            times_to_retry -= 1
            if (times_to_retry > 0)
              sleep(@storage_config.sleep_on_retry)
            else
              message = "DSS: Unable to save file #{source} to #{destination}, error: #{$!.message}"
              @logger.error(message)
              raise message
            end            
          end          
        end        
      end
      
         
    end
    
    
    
  end
end
