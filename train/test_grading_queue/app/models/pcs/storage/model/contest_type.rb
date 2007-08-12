require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class ContestType < ActiveRecord::Base
        set_primary_key "contest_type_id"
        
        has_many :contests
        
      end
      
      
    end
end