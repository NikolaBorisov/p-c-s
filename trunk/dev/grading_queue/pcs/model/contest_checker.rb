require 'rubygems'
gem 'activerecord'
require 'active_record'


class PCS::Model::ContestChecker < ActiveRecord::Base
  set_primary_key "contest_checker_id"
  set_table_name "contests_checkers"
  
  # Keep this synchronized
  SUBMIT_ACTION = 1
  GRADE_ACTION = 2  
  ACTIONS = [["Submit", SUBMIT_ACTION],["Grade", GRADE_ACTION]]
  
  belongs_to :contest
  belongs_to :checker
  belongs_to :task
  
  
end