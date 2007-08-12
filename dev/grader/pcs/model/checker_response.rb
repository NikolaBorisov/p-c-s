require 'rubygems'
gem 'activerecord'
require 'active_record'
require 'pcs/checker_response.rb'


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
          if (checker_response.nil?)
            return
          end
          self.status = checker_response.status unless checker_response.status.nil?
          self.message = checker_response.message unless checker_response.message.nil?
          self.correctness = checker_response.correctness unless checker_response.correctness.nil?
          self.user_time = checker_response.user_time unless checker_response.user_time.nil?
          self.system_time = checker_response.system_time unless checker_response.system_time.nil?
          self.exit_status = checker_response.exit_status unless checker_response.exit_status.nil?
          self.term_sig = checker_response.term_sig unless checker_response.term_sig.nil?
        end
        
      end
      
      
      
    end
end