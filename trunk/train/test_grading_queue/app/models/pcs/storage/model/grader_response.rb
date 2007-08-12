#require 'module.rb'


module PCS
    module Model
      
      
      
      class GraderResponse < ActiveRecord::Base
        IN_QUEUE = 1
        GRADING = 2
        READY = 3
      
        set_primary_key "grader_response_id"
        
        belongs_to :solution_compiler_response, :class_name => "CompilerResponse", 
          :foreign_key => "solution_compiler_response_id"
        
        belongs_to :checker_compiler_response, :class_name => "CompilerResponse",
          :foreign_key => "checker_compiler_response_id"
        
        has_many :test_responses
        
        belongs_to :submit
        
        belongs_to :checker
        
        belongs_to :modul, :class_name => 'PCS::Model::Module'
      
        def fill_with(a_grader_response)
          self.solution_compiler_response.fill_with(a_grader_response.solution_compiler_response)
          self.checker_compiler_response.fill_with(a_grader_response.checker_compiler_response)
          a_grader_response.test_responses.each do |test_response|
            tr = PCS::Model::TestResponse.new
            tr.fill_with(test_response)
            self.test_responses << tr
            tr.grader_response = self
#            tr.save!
          end
        end
     
      end
      
      
      
    end
end