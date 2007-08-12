require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class Submit < ActiveRecord::Base
        set_primary_key "submit_id"
        
        belongs_to :user
        
        belongs_to :task
        
        belongs_to :file
        
        belongs_to :program_language
        
        has_and_belongs_to_many :contests
        
        has_many :grader_responses
        
      end
      
      
    end
end