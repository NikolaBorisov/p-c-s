require 'rubygems'
gem 'activerecord'
require 'active_record'


module PCS
  module Model
    
    
    
    class Submit < ActiveRecord::Base
      set_primary_key "submit_id"
      
      belongs_to :user
      
      belongs_to :task
      
      belongs_to :file
      
      belongs_to :program_language
      
      belongs_to :contest
      
      has_many :grader_responses
    end
    
    
    
  end
end