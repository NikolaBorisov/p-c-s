require 'rubygems'
gem 'activerecord'
require 'active_record'

module PCS
    module Model
      
      
      class TaskContent < ActiveRecord::Base
        set_primary_key "task_content_id"
        
        belongs_to :language
        belongs_to :task
        
        
        
      end
            
    end
end