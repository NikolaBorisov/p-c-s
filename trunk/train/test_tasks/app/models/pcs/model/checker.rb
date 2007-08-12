require 'rubygems'
gem 'activerecord'
require 'active_record'


class PCS::Model::Checker < ActiveRecord::Base
  set_primary_key "checker_id"
  
  belongs_to :task
  
  belongs_to :file
  
  belongs_to :program_language
  
  has_many :grader_responses
  
  has_many :contests_checkers, :class_name => "PCS::Model::ContestChecker"
  
  #Methods
   def after_destroy()
        self.file.destroy() if( self.file )
   end
end