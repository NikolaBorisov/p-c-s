require 'rubygems'
gem 'activerecord'
require 'active_record'


class PCS::Model::Role < ActiveRecord::Base
  set_primary_key "role_id"
  has_and_belongs_to_many :users
end
