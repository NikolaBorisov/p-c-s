require 'rubygems'
gem 'activerecord'
require 'active_record'


class PCS::Model::Module < ActiveRecord::Base
  set_primary_key "module_id"
  
  belongs_to :task
  
  has_many :modules_files, :class_name => "PCS::Model::ModuleFile", :dependent => :destroy
  has_many :files, :through => :modules_files, :dependent => :destroy
  
  has_many :grader_responses
  
  has_many :contests_modules, :class_name => "PCS:Model::ContestModule"
  
end
