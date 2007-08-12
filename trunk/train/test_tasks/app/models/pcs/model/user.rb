require 'rubygems'
gem 'activerecord'
require 'active_record'
require 'digest/sha1'


module PCS
  module Model
    
    
    class User < ActiveRecord::Base
     set_primary_key "user_id"
      
     belongs_to :country
      
     has_many :submits
      
     has_and_belongs_to_many :roles #, :class_name => "PCS::Model::Role"
      
     has_and_belongs_to_many :articles,
     :join_table => "articles_privileges"
      
     has_and_belongs_to_many :tasks,
     :join_table => "tasks_privileges"
     
     has_many :contests_users, :class_name => "PCS::Model::ContestPrivilege", :dependent => :destroy
     has_many :privileged_contests, :through => :contests_users, :source => :contest
      
     attr_accessor :text_password_confirmation
      
     validates_presence_of(:first_name, :last_name, :username,
                           :city, :email )
      
     validates_presence_of(:text_password, :text_password_confirmation, :on => :create)
      
     validates_format_of(:text_password, :with => /^\S*$/, :message => "can include only letters, numbers, and special symbols")
      
     validates_confirmation_of(:text_password)
      
     validates_uniqueness_of(:username, :message => "This user name is occupied")
      
     validates_format_of(:username, :with => /^\w*$/, :message => "can include only letters, numbers and underscores")
      
     validates_length_of(:username, :within => 2..25)
      
     validates_format_of(:email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)
      
     validates_length_of(:text_password, :within => 6..20, :on => :create)
      
      validates_length_of(:first_name, :maximum => 64)
      validates_length_of(:last_name, :maximum => 64)
      validates_length_of(:email, :maximum => 128)
      validates_length_of(:city, :maximum => 64)
      
      validates_length_of(:school, :maximum => 128, :allow_nil => true)
      validates_length_of(:address, :maximum => 512, :allow_nil => true)
      
      def self.authenticate(name, password)
        user = self.find_by_username(name)
        if user
          typed_password = self.encrypted_password(password)
          puts user.password, typed_password
          if user.password != typed_password
            user = nil
          end
        end
        user
      end
      
      def text_password
        return @text_password
      end
      
      def text_password=(pwd)
        @text_password = pwd
        self.password = User.encrypted_password(pwd)
      end
      
      def after_create
        @text_password = self.text_password_confirmation = nil;
      end  
      
      private 
      
      def self.encrypted_password(pwd)
        return Digest::SHA1.hexdigest(pwd)
      end
      
    end
    
  end
end