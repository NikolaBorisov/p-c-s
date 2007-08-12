require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      
      class Role < ActiveRecord::Base
        has_and_belongs_to_many :users
      end
      
      
      
    end
end