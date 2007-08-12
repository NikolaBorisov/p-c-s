require 'rubygems'
gem 'activerecord'
require 'active_record'



class PCS::Model::ModuleFile < ActiveRecord::Base
  set_primary_key "module_file_id"
  set_table_name "modules_files"
  
  belongs_to :modul, :class_name => "PCS::Model::Module"
  belongs_to :file
  
  #Methods 
  def after_destroy()
    self.file.destroy() if( self.file )
  end
end
