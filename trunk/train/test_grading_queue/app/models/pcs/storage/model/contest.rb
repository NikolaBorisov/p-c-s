require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class Contest < ActiveRecord::Base
        set_primary_key "contest_id"
        
        belongs_to :owner,
        :class_name => "User",
        :foreign_key => "owner_id"
        
        belongs_to :contest_type
        belongs_to :board_type
        
        has_and_belongs_to_many :tasks,
        :order => "number"
        
        has_and_belongs_to_many :privileged_users,
        :class_name => "User",
        :join_table => "contest_privileges"
        
        has_and_belongs_to_many :submits
        
      end
      
      
    end
end