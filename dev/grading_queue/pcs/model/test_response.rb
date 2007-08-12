require 'rubygems'
gem 'activerecord'
require 'active_record'
require 'pcs/model/checker_response'
require 'pcs/test_response.rb'
require 'pcs/checker_response.rb'


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
        
        #TODO: Consider reimplementation of this functions
        def fill_with(test_response)
          if (test_response.nil?) 
            return
          end
          self.status = test_response.status unless test_response.status.nil?
          self.message = test_response.message unless test_response.message.nil?
          self.user_time = test_response.user_time unless test_response.user_time.nil?
          self.system_time = test_response.system_time unless test_response.system_time.nil?
          self.memory_usage = test_response.memory_usage unless test_response.memory_usage.nil?
          self.exit_status = test_response.exit_status unless test_response.exit_status.nil?
          self.term_sig = test_response.term_sig unless test_response.term_sig.nil?
          puts "TEST ID IS", test_response.test_id
          self.test = PCS::Model::Test.find(test_response.test_id) unless test_response.test_id.nil?
          self.checker_response = PCS::Model::CheckerResponse.new
          self.checker_response.fill_with(test_response.checker_response) unless test_response.checker_response.nil?
        end
        
      end
      
      
      
    end
end