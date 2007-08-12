require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      
      class CheckerResponse < ActiveRecord::Base
      
        CORRECT = 0
        WRONG_ANSWER = 1
        EXCEESIVE_OUTPUT = 2
        PRESENTATION_ERROR = 3
        TIME_LIMIT = 4
        INTERNAL_ERROR = -1
        
        set_primary_key "checker_response_id"
        
        has_one :test_response
        
        def fill_with(checker_response)
          self.status = checker_response.status
          self.message = checker_response.message
          self.correctness = checker_response.correctness
          self.user_time = checker_response.user_time
          self.system_time = checker_response.system_time
          self.exit_status = checker_response.exit_status
          self.term_sig = checker_response.term_sig
        end
        
      end
      
      
      
    end
end