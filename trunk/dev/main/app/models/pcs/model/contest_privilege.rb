require 'rubygems'
gem 'activerecord'
require 'active_record'


module PCS
  module Model  
  
      class ContestPrivilege < ActiveRecord::Base
        set_table_name "contest_privileges"
        
        belongs_to :contest
        belongs_to :user
        
      end
      
  end
end