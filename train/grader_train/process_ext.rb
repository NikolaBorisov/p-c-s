module Process
  Process::RLIMIT_CPU = 0
  Process::RLIMIT_AS = 0
  Process::RLIMIT_FSIZE = 0
  
  def self.setrlimit(resourse,cur_limit)
       
  end

  def self.getrusage(pid)
    rusage = Hash.new
    ru_utime = Hash.new
    ru_stime = Hash.new
    
    ru_utime[:tv_sec] = 0
    ru_utime[:tv_usec] = 13000
    
    ru_stime[:tv_sec] = 0
    ru_stime[:tv_usec] = 13000
    
    rusage[:ru_utime] = ru_utime
    rusage[:ru_stime] = ru_stime
    rusage
  end
end
