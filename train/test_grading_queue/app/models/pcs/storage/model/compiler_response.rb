require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class CompilerResponse < ActiveRecord::Base
        INTERNAL_ERROR = -1
        OK = 0
        TIME_LIMIT = 1
        COMPILATION_ERROR = 2
        COMPILATION_RECEIVED_SIGNAL = 3
        
        set_primary_key "compiler_response_id"
        
        has_one :grader_response_solution, :class_name => "GraderResponse",
          :foreign_key => "solution_compiler_response_id"
        
        has_one :grader_response_checker, :class_name => "GraderResponse",
          :foreign_key => "checker_compiler_response_id"
        
        def fill_with(compiler_response)
          self.status = compiler_response.status
          self.message = compiler_response.message
          self.compiler_output = compiler_response.compiler_output
          self.user_time = compiler_response.user_time
          self.system_time = compiler_response.system_time
          self.exit_status = compiler_response.exit_status
          self.term_sig = compiler_response.term_sig
        end
        
      end
      
      
      
    end
end