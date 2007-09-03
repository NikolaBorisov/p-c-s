require 'rubygems'
gem 'activerecord'
require 'active_record'


class PCS::Model::Contest < ActiveRecord::Base
  RUNNING = "running"
  STOPPED = "stopped"

  set_primary_key "contest_id"

  belongs_to :owner,
  :class_name => "User",
  :foreign_key => "owner_id"

  belongs_to :contest_type
  belongs_to :board_type

  has_many :contests_tasks, :class_name => "PCS::Model::ContestTask", :order => 'number', :dependent => :destroy
  has_many :tasks, :through => :contests_tasks

  has_many :contests_users, :class_name => "PCS::Model::ContestPrivilege", :dependent => :destroy
  has_many :privileged_users, :through => :contests_users, :source => :user


  has_many :submits

  has_many :contests_modules,
  :class_name => "PCS::Model::ContestModule",
  :dependent => :destroy

  has_many :contests_checkers,
  :class_name => "PCS::Model::ContestChecker",
  :dependent => :destroy

end
