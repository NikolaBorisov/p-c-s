require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model  
      
      
      
      class Test < ActiveRecord::Base
        set_primary_key "test_id"
        
        belongs_to :task
        
        has_many :test_files
        has_many :files, :through => :test_files
        
        has_many :test_responses
        
      end
      
      
      
    end
end