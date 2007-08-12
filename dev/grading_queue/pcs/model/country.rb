require 'rubygems'
gem 'activerecord'
require 'active_record'


module PCS
    module Model
      
      
      
      class Country < ActiveRecord::Base
        set_primary_key "country_id"
        
        has_many :users
        
        validates_presence_of :name, :code
        validates_uniqueness_of :name, :code
        
      end
      
      
      
    end
end