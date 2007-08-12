module PCS
  
  
  
  class TestResponse
  
    INTERNAL_ERROR = -1
    OK = 0
    TIME_LIMIT = 1
    SEGMENTATION_FAULT = 2
    KILL_SIGNAL = 3
    EXCEESIVE_OUTPUT = 4
    EXECUTION_ERROR = 5
    COMPILATION_ERROR = 6
    
    attr_accessor :status, :message, :user_time, :system_time, :memory_usage
    attr_accessor :exit_status, :term_sig, :test_id
    attr_accessor :checker_response
    
  end
  
  
  
end
