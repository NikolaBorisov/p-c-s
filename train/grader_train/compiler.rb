
require 'process_ext'

class Compiler
  def self.compile(language, sources, destination, options, compile_time_limit)
    cmd_line = [];
    language.upcase!
    
    sources = copy_sources(sources, language)
    
    if ( language == "C" )
      cmd_line.push("gcc","-o",destination)
    elsif ( language == "C++" )
      cmd_line.push("g++","-o",destination)
    elsif ( language == "PASCAL" )
      cmd_line.push("fpc","-o"+desitnation)
    else 
      raise "Cannot compile - unsupported language"
    end
    
    cmd_line.push(*options)
    cmd_line.push(*sources)
        
    puts *cmd_line
    
    child_output_read, child_output_write = IO.pipe
    child_error_read, child_error_write = IO.pipe
    
    child_pid = fork do
      child_output_read.close
      child_error_read.close
      
      $stdout.reopen(child_output_write) or
        raise "Unable to redirect STDOUT"
      $stderr.reopen(child_error_write) or
        raise "Unable to redirect STDERR"
      
      Process.setrlimit(Process::RLIMIT_CPU, compile_time_limit)
      
      exec *cmd_line
    end
    
    child_output_write.close
    child_error_write.close
          
    pid, status = Process.wait2(child_pid)
    
    resources_used = Process.getrusage(child_pid)

    user_time = resources_used[:ru_utime][:tv_sec]*1000 + resources_used[:ru_utime][:tv_usec]/1000 
    sys_time = resources_used[:ru_stime][:tv_sec]*1000 + resources_used[:ru_stime][:tv_usec]/1000 

    compiler_response = Hash.new
        
    if ( user_time + sys_time > compile_time_limit*1000 )
      compiler_response[:status] = 1
      compiler_response[:message] = "Compile Time Limit Exceeded"
    elsif ( status.exitstatus != 0 )
      compiler_response[:status] = 2
      compiler_response[:message] = "Compile Error"
    else
      compiler_response[:status] = 0
      compiler_response[:message] = "OK"
    end
    
    compiler_response[:compiler_output] = (child_output_read.readlines + child_error_read.readlines).join
    compiler_response[:user_time] = user_time
    compiler_response[:sys_time] = sys_time
    compiler_response[:exit_status] = status.exitstatus
    return compiler_response
  end
    
  def self.copy_sources(sources, lang)
    new_sources = []
    if ( lang=="C" )
      suffix = ".c"
    elsif ( lang=="C++" )
      suffix = ".cpp"
    elsif ( lang=="PASCAL")
      suffix = ".pas"
    else
      raise "Undefined Lnaguage"
    end
    id = 1;
    sources.each do |file|
      new_file_name = "./tmp/user.source"+id.to_s+suffix
      system "cp", file, new_file_name
      new_sources << new_file_name
    end
    new_sources
  end
end

#Compiler.compile("C++",["./tmp/slow.c"],"./tmp/test_program.bin",["-O2","-lm"],3)

