require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class File < ActiveRecord::Base
        set_primary_key "file_id"
        
        has_and_belongs_to_many :articles
        
        has_many :test_files
        
        has_many :tests, :through => :test_files
        
        has_many :module_files
        
        has_many :modules, :through => :module_files
        
        has_one :checker
        
        has_one :sample_solution
        
        has_one :submit
        
      end
      
      
    end
end
