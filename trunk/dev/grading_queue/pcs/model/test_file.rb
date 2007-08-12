require 'rubygems'
gem 'activerecord'
require 'active_record'


class PCS::Model::TestFile < ActiveRecord::Base
  set_primary_key "test_file_id"
  set_table_name "tests_files"
  
  belongs_to :test
  belongs_to :file
  
  #Methods
  def after_destroy()
    self.file.destroy() if( self.file )
  end
  
  
end
