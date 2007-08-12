require 'rubygems'
require_gem 'activerecord'
require 'pcs/model/checker_response'

module PCS
    module Model
      
      
      
      class TestResponse < ActiveRecord::Base
        INTERNAL_ERROR = -1
        OK = 0
        TIME_LIMIT = 1
        SEGMENTATION_FAULT = 2
        KILL_SIGNAL = 3
        EXCEESIVE_OUTPUT = 4
        EXECUTION_ERROR = 5
        COMPILATION_ERROR = 6
        
        set_primary_key "test_response_id"
        
        belongs_to :checker_response
        
        belongs_to :grader_response
        
        belongs_to :test
        
        def fill_with(test_response)
          self.status = test_response.status
          self.message = test_response.message
          self.user_time = test_response.user_time
          self.system_time = test_response.system_time
          self.memory_usage = test_response.memory_usage
          self.exit_status = test_response.exit_status
          self.term_sig = test_response.term_sig
          self.test = PCS::Model::Test.find(test_response.test_id)
          self.checker_response = PCS::Model::CheckerResponse.new
          self.checker_response.fill_with(test_response.checker_response)
#          self.checker_response.save!
 #         puts "Checker_Response ID = #{self.checker_response.id}"
        end
        
      end
      
      
      
    end
end