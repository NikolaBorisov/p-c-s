require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class Classes < ActiveRecord::Base
        set_table_name "classes"
        set_primary_key "class_id"
        
        has_and_belongs_to_many :articles,
        :join_table => "articles_classes",
        :foreign_key => "class_id"
        
        has_and_belongs_to_many :tasks,
        :join_table => "tasks_classes",
        :foreign_key => "class_id"
        
      end
      
      
      
    end
end