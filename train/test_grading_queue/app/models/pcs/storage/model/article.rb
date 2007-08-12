require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class Article < ActiveRecord::Base
        set_primary_key "article_id"
        
        belongs_to :owner,
        :class_name => "User",
        :foreign_key => "owner_id"
        
        has_and_belongs_to_many :privileged_users,
        :class_name => "User",
        :join_table => "articles_privileges"
        
        has_and_belongs_to_many :classes,
        :join_table => "articles_classes",
        :association_foreign_key => "class_id"  
      end
      
      
    end
end