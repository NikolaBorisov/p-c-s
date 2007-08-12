module PCS
  
  
  
  class CompilerResponse
    
    INTERNAL_ERROR = -1
    OK = 0
    TIME_LIMIT = 1
    COMPILATION_ERROR = 2
    COMPILATION_RECEIVED_SIGNAL = 3
    
    attr_accessor :status, :message, :compiler_output, :user_time, :system_time
    attr_accessor :exit_status, :term_sig
    
  end
  
  
  
end
