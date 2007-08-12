require 'pcs/ext/process'
require 'pcs/utils'
require 'pcs/compiler_option'

module PCS
  module Grader
    
    
    
    class Compiler
      
      COMPILER_OUTPUT_FILE = 'compiler.output.txt'
      COMPILER_ERROR_FILE = 'compiler.error.txt'
      
      
      def initialize(compiler_root, logger)
        @compiler_root = compiler_root
        @logger = logger
        begin
          Utils.create_directory(compiler_root)
          clear_directory
        rescue 
          message = "Commpiler: Cannot create compiler directories #{@compiler_root}, error: #{$!.message}"
          @logger.error(message)
          raise message
        end
      end
      
      
      def clear_directory
        Utils.clear_directory(@compiler_root)
      end
      
      
      #
      # This method compiles the full path filenames given in the string sources(separated by 
      # whitespace) in a given destination using the predefined command_line given
      #
      def compile(sources, destination, include_path, options)
        
        cmd_line = options.command_line
        cmd_line.gsub!(CompilerOption::SOURCE_PATTERN, sources)
        cmd_line.gsub!(CompilerOption::DESTINATION_PATTERN, destination)
        cmd_line.gsub!(CompilerOption::INCLUDE_PATH_PATTERN, include_path)
        
        @logger.info("Compiler: Compiling with the following command line: #{cmd_line}") if @logger
        
        child_pid = fork do
          
          # Redirects standart output and error streams to files
          begin
            $stdout.reopen(File.join(@compiler_root, COMPILER_OUTPUT_FILE), "w")
            $stderr.reopen(File.join(@compiler_root, COMPILER_ERROR_FILE), "w")
            
            Process.setrlimit(Process::RLIMIT_CPU, options.time_limit)
          rescue
            message = $!
            @logger.error(message) if @logger
            exit(-1)
          end
                    
          exec cmd_line        
        end
        
        status, resources_used = Process.wait4(child_pid)
       
        user_time = resources_used[:ru_utime_sec] * 1000 + resources_used[:ru_utime_usec] / 1000
        system_time = resources_used[:ru_stime_sec] * 1000 + resources_used[:ru_stime_usec]/ 1000
        
        @logger.info("Compilation User Time:#{user_time} System Time:#{system_time}") if @logger
        
        compiler_response = CompilerResponse.new
        
        if (user_time  > options.time_limit*1000)
          compiler_response.status = CompilerResponse::TIME_LIMIT
          compiler_response.message = "Compile Time Limit Exceeded"
        elsif ( status.exitstatus ==  CompilerResponse::INTERNAL_ERROR )
          compiler_response.status = CompilerResponse::INTERNAL_ERROR
          compiler_response.message = "Internal Compilation Error"
        elsif ( status.exitstatus != 0 )
          compiler_response.status = CompilerResponse::COMPILATION_ERROR
          compiler_response.message = "Compilation Error"
        elsif ( status.termsig != nil )
          compiler_response.status = CompilerResponse::COMPILATION_RECEIVED_SIGNAL
          compiler_response.message = "Compilation Reseived Signal"
        else
          compiler_response.status = CompilerResponse::OK
          compiler_response.message = "OK"
        end
        
        compiler_response.compiler_output = IO.read(File.join(@compiler_root, COMPILER_OUTPUT_FILE)) +
        IO.read(File.join(@compiler_root, COMPILER_ERROR_FILE))
        @logger.debug("Compiler: Compiler outputed: #{compiler_response.compiler_output}") if @logger
        
        compiler_response.user_time = user_time
        compiler_response.system_time = system_time
        compiler_response.exit_status = status.exitstatus
        compiler_response.term_sig = status.termsig
        
        return compiler_response
      end
      
    end
    
    
    
  end
end
