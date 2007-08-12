#This script fills the database with little some for testing purpose

require 'rubygems'
require_gem 'activerecord'

require 'pcs/model/role'
require 'pcs/model/user'
require 'pcs/model/country'

require 'digest/sha1'



ActiveRecord::Base.establish_connection(
  :adapter => 'mysql',
  :host => 'localhost',
  :port => 3307,
  :database => 'pcs',
  :username => 'pcs',
  :password => '1234'
)

# Add new role type
role1 = PCS::Model::Role.find_by_name("author")
if ( role1 == nil )
  role1 = PCS::Model::Role.new()
  role1.name = "author"
  role1.save()
end

# Add some countries
country1 = PCS::Model::Country.find_by_name("Bulgaria")
if( country1 == nil)
  country1 = PCS::Model::Country.new()
  country1.name = 'Bulgaria'
  country1.code = 'bg'
  country1.save()
end

#add author_user with role author 
user1 = PCS::Model::User.find_by_username("author1")
if( user1 == nil )
  user1 = PCS::Model::User.new()
  user1.username = 'author1'
  user1.password =  Digest::SHA1.hexdigest('easy_password')  
  user1.country = country1  
  user1.save()
end

user1.roles << role1
user1.save()

#add some programming languages
lang1 = PCS::Model::ProgramLanguage.find_by_name("c")
unless( lang1 )
  lang1 = PCS::Model::ProgramLanguage.new()
  lang1.name = "c"
  lang1.save()
end

lang1 = PCS::Model::ProgramLanguage.find_by_name("c++")
unless( lang1 )
  lang1 = PCS::Model::ProgramLanguage.new()
  lang1.name = "c++"
  lang1.save()
end

lang1 = PCS::Model::ProgramLanguage.find_by_name("pascal")
unless( lang1 )
  lang1 = PCS::Model::ProgramLanguage.new()
  lang1.name = "pascal"
  lang1.save()
end

lang1 = PCS::Model::ProgramLanguage.find_by_name("java")
unless( lang1 )
  lang1 = PCS::Model::ProgramLanguage.new()
  lang1.name = "java"
  lang1.save()
end



#add some languages
lang1 = PCS::Model::Language.find_by_name("english")
unless( lang1 )
  lang1 = PCS::Model::Language.new()
  lang1.name = "english"
  lang1.code = "en"
  lang1.save()
end

lang1 = PCS::Model::Language.find_by_name("bulgarian")
unless( lang1 )
  lang1 = PCS::Model::Language.new()
  lang1.name = "bulgarian"
  lang1.code = "bg"
  lang1.save()
end

lang1 = PCS::Model::Language.find_by_name("russian")
unless( lang1 )
  lang1 = PCS::Model::Language.new()
  lang1.name = "russian"
  lang1.code = "ru"
  lang1.save()
end




