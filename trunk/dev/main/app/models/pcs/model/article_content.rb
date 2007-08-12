require 'rubygems'
gem 'activerecord'
require 'active_record'


class PCS::Model::ArticleContent < ActiveRecord::Base
  set_primary_key "article_content_id"
  
  belongs_to :language
  
  belongs_to :article
  
end
