
module PCS
  module GradingQueue
    
    
    
    class Job
      NO_GRADER = -1
      attr_accessor :id
      attr_accessor :grader_id, :problem_id, :submit_id, :test_id, :checker_id, :module_id
      
      def initialize(grader_id, problem_id, submit_id, test_id,  checker_id, module_id)
        @grader_id = grader_id
        @problem_id = problem_id
        @submit_id = submit_id
        @test_id = test_id
        @checker_id = checker_id
        @module_id = module_id
      end
      
    end
    
    
  end
end