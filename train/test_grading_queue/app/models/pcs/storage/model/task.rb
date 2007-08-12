require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class Task < ActiveRecord::Base
        set_primary_key "task_id"
        
        belongs_to :owner,
        :class_name => "User",
        :foreign_key => "owner_id"
        
        has_many :contents,
        :class_name => "TaskContent"
        
        has_many :tests,
        :order => "number"
        
        has_many :modules
        
        has_many :restrictions
        
        has_many :checkers
        
        has_many :sample_solutions
        
        has_many :submits
        
        has_and_belongs_to_many :privileged_users,
        :class_name => "User",
        :join_table => "tasks_privileges"
        
        has_and_belongs_to_many :classes,
        :join_table => "tasks_classes",
        :association_foreign_key => "class_id"
        
        has_and_belongs_to_many :files,
        :join_table => "tasks_files"
        
        has_and_belongs_to_many :contests
        
      end
      
      
    end
end