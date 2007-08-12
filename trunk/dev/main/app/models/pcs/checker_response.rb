module PCS
  
  #
  # This class holds the result of che checker.
  #
  class CheckerResponse
    
    CORRECT = 0
    WRONG_ANSWER = 1
    EXCEESIVE_OUTPUT = 2
    PRESENTATION_ERROR = 3
    TIME_LIMIT = 4
    INTERNAL_ERROR = -1
    
    #
    # status is one of the predefined constants
    #
    attr_accessor :status
    
    #
    # message is string holding the checker message
    #
    attr_accessor :message
    
    #
    # This is a number betwen 0 and 100 stating the persantage of
    # point this answer deserves
    #
    attr_accessor :correctness
    
    #
    # The time needed for the checker to check the answer 
    #
    attr_accessor :user_time
    attr_accessor :system_time
    
    #
    # Checkers exit status
    #
    attr_accessor :exit_status, :term_sig
    
    def initialize
      @status = INTERNAL_ERROR
      @message = "Uninitialized"
      @correctness = 0
      @user_time = @system_time = @exit_status = 0
    end
    
  end
  
  
  
end