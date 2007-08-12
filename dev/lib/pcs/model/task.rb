require 'rubygems'
gem 'activerecord'
require 'active_record'

module PCS
    module Model
      
      
      class Task < ActiveRecord::Base
        set_primary_key "task_id"
      
        
        belongs_to :owner,
        :class_name => "User",
        :foreign_key => "owner_id"
        
        has_many :contents,
        :class_name => "TaskContent", :dependent => :destroy
        
        has_many :tests,
        :order => "number", :dependent => :destroy
        
        has_many :modules, :dependent => :destroy
        
        has_many :restrictions, :dependent => :destroy
        
        has_many :checkers, :dependent => :destroy
        
        has_many :sample_solutions, :dependent => :destroy
        
        has_many :submits, :dependent => :destroy
        
        has_and_belongs_to_many :privileged_users,
        :class_name => "PCS::Model::User",
        :join_table => "tasks_privileges"
        
        has_and_belongs_to_many :classes,
        :class_name => "PCS::Model::Classes",        
        :join_table => "tasks_classes",
        :association_foreign_key => "class_id"
        
      #  has_and_belongs_to_many :files,
      #  :join_table => "tasks_files"
        
        has_many :contests_tasks, :class_name => "PCS::Model::ContestTask", :dependent => :destroy
        has_many :contests, :through => :contests_tasks
        
        has_many :contests_modules, :class_name => "PCS::Model::ContestModule", :dependent => :destroy
        has_many :contests_checkers, :class_name => "PCS::Model::ContestChecker", :dependent => :destroy
        
        
        #Methods
               
      end
      
      
    end
end