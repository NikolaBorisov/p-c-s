module PCS
  
  
  
  class GraderResponse
    
    attr_accessor :solution_compiler_response, :checker_compiler_response, :test_responses
    
    def initialize
      @test_responses = []
    end
  end
  
  
  
end
