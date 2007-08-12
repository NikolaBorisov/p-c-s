require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class ProgramLanguage < ActiveRecord::Base
        set_primary_key "program_language_id"
        
        has_many :submits
        
        has_many :compiler_options
        
      end
      
      
      
    end
end