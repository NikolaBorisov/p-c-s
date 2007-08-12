require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class CompilerOption < ActiveRecord::Base
        set_primary_key "compiler_option_id"
        
        belongs_to :program_language
        
      end
      
      
      
    end
end