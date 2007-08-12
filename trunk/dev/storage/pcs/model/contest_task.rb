require 'rubygems'
gem 'activerecord'
require 'active_record'

class PCS::Model::ContestTask < ActiveRecord::Base
  
  set_table_name "contests_tasks"
  
  belongs_to :contest
  belongs_to :task
  belongs_to :restriction
  
  def before_destroy
    PCS::Model::ContestModule.destroy_all(["task_id = ? AND contest_id = ?", @task_id, @contest_id])
    PCS::Model::ContestChecker.destroy_all(["task_id = ? AND contest_id = ?", @task_id, @contest_id])    
  end
  
end