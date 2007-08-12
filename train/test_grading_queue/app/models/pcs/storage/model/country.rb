require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      
      class Country < ActiveRecord::Base
        set_primary_key "country_id"
        
        has_many :users
        
      end
      
      
      
    end
end