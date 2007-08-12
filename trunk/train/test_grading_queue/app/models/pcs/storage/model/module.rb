require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model 
      
      
      class Module < ActiveRecord::Base
        set_primary_key "module_id"
        
        belongs_to :task
        
        has_many :module_files
        has_many :files, :through => :module_files
        
        has_many :grader_responses
        
      end
      
      
    end
end