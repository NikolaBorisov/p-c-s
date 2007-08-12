require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      
      class SampleSolution < ActiveRecord::Base
        set_primary_key "sample_solution_id"
        
        belongs_to :task
        
        belongs_to :file
      end
      
      
      
    end
end