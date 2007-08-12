module PCS
  module Grader
    
    
    
    class GraderConfig
      CHECKER_TIME_LIMIT = 20000          # 20 sec
      CHECKER_MEMORY_LIMIT = 128 * 1024   # 128 MB
      CHECKER_OUTPUT_LIMIT = 2 * 1024     # 2MB
      CHECKER_COMPILE_OPTIONS = "-static"
      
      attr_reader   :exec_filename, :input_filename, :solution_filename
      attr_accessor :grader_root, :execute_uid, :grader_address, :user, :grader_ssh_port
      attr_accessor :logger_shift_age, :logger_shift_size, :logging_level, :logger_datetime_format
      
      
      def initialize
        @storage_directory = 'storage'
        @cache_directory = 'cache'
        @compiler_directory = 'compiler'
        @compiler_source_directory = 'sources'
        @compiler_lib_directory = 'lib'
        @test_directory = 'test'
        @exec_directory = 'exec'
        @logger_directory = 'log'
        @exec_filename = 'user.bin'
        @checker_filename = 'checker'
        @checker_output_filaname = 'checker.output'
        @input_filename = 'input'
        @output_filename = 'output'
        @solution_filename = 'solution'
        @error_filename = 'error'
        @logger_filename = 'grader.log'
        @execute_uid = -1
      end
      
      
      def storage_root
        return File.join(@grader_root, @storage_directory)
      end
      
      
      def cache_root
        return File.join(@grader_root, @cache_directory)
      end
      
      
      def compiler_root
        return File.join(@grader_root, @compiler_directory)
      end
      
      
      def sources_root
        return File.join(storage_root, @compiler_source_directory)
      end
      
      
      def lib_root
        return File.join(storage_root, @compiler_lib_directory)
      end
      
            
      def test_root
        return File.join(@grader_root, @test_directory)
      end
      
      
      def exec_root
        return File.join(@grader_root, @exec_directory)
      end
      
      
      def logger_root
        return File.join(@grader_root, @logger_directory)
      end
      
      
      def input_filepath
        return File.join(test_root, @input_filename)
      end
      
      
      def output_filepath
        return File.join(test_root, @output_filename)
      end
      
      
      def solution_filepath
        return File.join(test_root, @solution_filename)
      end
      
      
      def error_filepath
        return File.join(test_root, @error_filename)
      end
      
      
      def logger_filepath
        return File.join(logger_root, @logger_filename)
      end
      
      
      def checker_filepath
        return File.join(test_root, @checker_filename)
      end
      
      
      def checker_output_filepath
        return File.join(test_root, @checker_output_filaname)
      end
      
      
    end
    
    
    
  end
end
