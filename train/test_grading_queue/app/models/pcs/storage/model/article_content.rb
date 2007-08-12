require 'rubygems'
require_gem 'activerecord'


module PCS
    module Model
      
      
      class ArticleContent < ActiveRecord::Base
        set_primary_key "article_content_id"
        
        belongs_to :language
        
        belongs_to :article
        
      end
    end
end
