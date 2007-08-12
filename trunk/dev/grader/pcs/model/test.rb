require 'rubygems'
gem 'activerecord'
require 'active_record'


class PCS::Model::Test < ActiveRecord::Base
  set_primary_key "test_id"
  
  belongs_to :task
  
  
  has_many :tests_files, :class_name => "PCS::Model::TestFile", :dependent => :destroy
  has_many :files, :through => :tests_files, :dependent => :destroy
  
  has_many :test_responses
  
end
