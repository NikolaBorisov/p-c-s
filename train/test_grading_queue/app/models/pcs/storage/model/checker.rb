require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class Checker < ActiveRecord::Base
        set_primary_key "checker_id"
        
        belongs_to :task
        
        belongs_to :file
        
        belongs_to :program_language
        
        has_many :grader_responses
        
      end
      
      
      
    end
end