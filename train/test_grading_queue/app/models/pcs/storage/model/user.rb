require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      
      class User < ActiveRecord::Base
        set_primary_key "user_id"
        
        belongs_to :country
        
        has_many :submits
        
        has_and_belongs_to_many :roles
        
        has_and_belongs_to_many :articles,
        :join_table => "articles_privileges"
        
      end
      
      
      
    end
end