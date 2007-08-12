require 'rubygems'
gem 'activerecord'
require 'active_record'

module PCS
    module Model
      
      
      class Language < ActiveRecord::Base
        set_primary_key "language_id"
        
        has_many :article_contents
        
        has_many :task_contents
        
      end
      
      
    end
end