require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      
      class ModuleFile < ActiveRecord::Base
        set_primary_key "module_file_id"
        
        belongs_to :modul, :class_name => "Module"
        belongs_to :file
      end
      
      
      
    end
end
