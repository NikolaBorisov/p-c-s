require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model 
      
      
      
      class TestFile < ActiveRecord::Base
        set_primary_key "test_file_id"
        
        belongs_to :test
        belongs_to :file
      end
      
      
      
    end
end
