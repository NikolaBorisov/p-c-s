require 'rubygems'
gem 'activerecord'
require 'active_record'


module PCS
    module Model  
      
      
      
      class BoardType < ActiveRecord::Base
        set_primary_key "board_type_id"
        
        has_many :contests
      end
    end
end
