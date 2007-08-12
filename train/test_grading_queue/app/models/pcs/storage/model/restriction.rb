require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class Restriction < ActiveRecord::Base
        set_primary_key "restriction_id"
        
        belongs_to :task
      end
      
      
    end
end