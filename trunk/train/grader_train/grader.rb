require "storage.rb"
require "process_ext.rb"
#HOME_DIR = "/home/borisof/pcs/grader/"
HOME_DIR = "/home/borisof/workspace/Pcs/train/grader_train/"

class Grader 
  
  def self.test(problem_id, submit_id, test_id, checker_id, module_id) 
    
#    clean()
    
    problem_info = Storage.get_problem(problem_id)
    
    compiler_response = Storage.copy_solution_to(submit_id, module_id, HOME_DIR + "./box/user.bin")
#    puts compiler_response
    
    Storage.copy_test_to(test_id, HOME_DIR + "./data/")

    if ( compiler_response[:status] == 0 )
      test_response = execute(problem_info[:time_limit], 
        problem_info[:memory_limit],
        problem_info[:output_limit])
    elsif 
      test_response = {}      
      test_response[:status] = 6
      test_response[:message] = compiler_response[:message]
    end
    test_response[:compiler_response] = compiler_response
    
    if ( test_response[:status] == 0 )
      test_response[:checker_response] = check_answer()
    end
    return test_response
  end
  
  def self.clean
    system "rm" "#{HOME_DIR}./data/" "-r"
  end
  
  def self.execute(time_limit_msec, memory_limit_mb, output_limit_kb)

    Process.fork() do
    
      # Redirects STDIN STDOUT STDERR
      $stdin.reopen("./data/input", "r") or 
        raise "Unable to redirect STDIN"
      $stdout.reopen("./data/output", "w") or
        raise "Unable to redirect STDOUT"
      $stderr.reopen("./data/error", "w") or
        raise "Unable to redirect STDERR"

      # Restricts CPU usage
      Process.setrlimit(Process::RLIMIT_CPU, time_limit_msec/1000)
      # Restricts Memory usage
      Process.setrlimit(Process::RLIMIT_AS, memory_limit_mb*1024*1024)
      # Restricts output file size
      Process.setrlimit(Process::RLIMIT_FSIZE, output_limit_kb*1024)
      
      
      Dir.chdir("./box")
      Dir.chroot("./")
      Process::Sys.setuid(1001)
      
      exec "./user.bin"    
    end

    pid, status = Process.wait2()

    resources_used = Process.getrusage(pid)
    
    result = Hash.new    
    
    user_time = resources_used[:ru_utime][:tv_sec]*1000 + resources_used[:ru_utime][:tv_usec]/1000 
    sys_time = resources_used[:ru_stime][:tv_sec]*1000 + resources_used[:ru_stime][:tv_usec]/1000 
        
    if ( user_time > time_limit_msec )
      result[:status] = 1
      result[:message] = "Time Limit Exceeded"
    elsif ( status.termsig == Signal.list["SEGV"] )
      result[:status] = 2
      result[:message] = "Segmentation Fault(Invalid Memory Reference)"
    elsif ( status.termsig == Signal.list["XFSZ"] )
      result[:status] = 4
      result[:message] = "Excessive Output"
    elsif ( status.termsig == Signal.list["KILL"] )
      result[:status] = 3
      result[:message] = "Execution Error"
    elsif ( status.termsig==nil )
      result[:status] = 0
      result[:execution_status] = "OK"
    else
      result[:status] = 5
      result[:execution_status] = "Unknow Execution Error"
    end
    
    result[:user_time] = user_time
    result[:sys_time] = sys_time
    result[:mem_usage] = 0
    result[:exit_status] = status.exitstatus
    result[:term_sig] = status.termsig
    return result
  end
  
  def self.check_answer  
    cmd_line = ["#{HOME_DIR}./data/checker", "#{HOME_DIR}./data/input",
    "#{HOME_DIR}./data/output", "#{HOME_DIR}./data/solution"]
    
    checker_time_limit = 30
    
    child_output_read, child_output_write = IO.pipe
    child_error_read, child_error_write = IO.pipe
    
    child_pid = fork do
      child_output_read.close
      child_error_read.close
      
      $stdout.reopen(child_output_write) or
        raise "Unable to redirect STDOUT"
      $stderr.reopen(child_error_write) or
        raise "Unable to redirect STDERR"
      
      Process.setrlimit(Process::RLIMIT_CPU, checker_time_limit)
      
      exec *cmd_line
    end
    
    child_output_write.close
    child_error_write.close
          
    pid, status = Process.wait2(child_pid)  
    
    checker_response = {}
    
    score = child_output_read.readline.to_i or 0
    raise "Checker Returned Score Out of Rainge" if ( score<0 || score>100 )
    checker_response[:checker_score] =  score;
    checker_response[:checker_message] = (child_output_read.readlines + child_error_read.readlines).join
    return checker_response
  end
  
end

puts Grader.test(0,0,0,0,0)
#Grader.execute(2000,50,2000)
#puts Grader.get_responce()