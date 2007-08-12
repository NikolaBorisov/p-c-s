require 'rubygems'
gem 'activerecord'
require 'active_record'


class PCS::Model::ContestModule < ActiveRecord::Base
  set_primary_key "contest_module_id"
  set_table_name "contests_modules"
  
  # Keep this syncronized
  SUBMIT_ACTION = 1
  GRADE_ACTION = 2
  ACTIONS = [["Submit", SUBMIT_ACTION],["Grade", GRADE_ACTION]]
  
  belongs_to :contest
  belongs_to :modul, :class_name => "PCS::Model::Module"
  belongs_to :program_language
  belongs_to :task
  
  
end