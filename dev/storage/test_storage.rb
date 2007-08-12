require 'pcs/model/language'
require 'pcs/model/file'
require 'pcs/model/checker'
require 'pcs/model/module'
require 'pcs/model/test'
require 'pcs/model/country'
require 'pcs/model/user'
require 'pcs/model/task'
require 'pcs/model/restriction'
require 'pcs/model/submit'
require 'pcs/model/program_language'
require 'pcs/model/compiler_option'
require 'digest/sha1'


ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "judge.openfmi.net",
  :port     => "3307",
  :database => "pcs",
  :username => "pcs",
  :password => "1234")
  

bg = PCS::Model::Language.new
bg.name = "English"
bg.code = "EN"
bg.save

country = PCS::Model::Country.new
country.name = "Bulgaria"

role = PCS::Model::Role.new
role.name = "admin"
role.save

user = PCS::Model::User.new
user.country = country
user.username = "koza"
user.password = Digest::SHA1.hexdigest('pase')
user.roles << role
user.save

role = PCS::Model::Role.new
role.name = "contestant"
role.save

user = PCS::Model::User.new
user.country = country
user.username = "koza1"
user.password = Digest::SHA1.hexdigest('pase1')
user.roles << role
user.save

task = PCS::Model::Task.new
task.title = "Prime Numbers"
task.name = "prime"
task.owner = user

contest = PCS::Model::Contest.new
contest.owner = user
contest.title = "Esenen Turnir Shumen 2006 grupa A"
contest.name = "fall2006A"
contest.contest_type = PCS::Model::ContestType.new
contest.contest_type.name = "IOI"
contest.board_type = PCS::Model::BoardType.new
contest.board_type.name = "IOI"

restriction = PCS::Model::Restriction.new
restriction.runtime = 10000
restriction.memory = 32000
restriction.output_size = 2000
task.restrictions << restriction
task.save!
contest.save!
ct = PCS::Model::ContestTask.new
ct.task = task
ct.contest = contest
ct.number = 1
ct.save!

lang = PCS::Model::ProgramLanguage.new
lang.name = 'C++'

compiler_option = PCS::Model::CompilerOption.new
compiler_option.command_line = 'g++ -O2 -static -I#INCLUDE_PATH# -o #DESTINATION# #SOURCES#'
compiler_option.program_language = lang
compiler_option.time_limit = 10000
lang.compiler_options << compiler_option
compiler_option.save!
lang.save!


file = PCS::Model::File.new
file.name = 'slow.checker.cpp'

checker = PCS::Model::Checker.new
checker.name = 'stupit'
checker.file = file
checker.task = task
checker.program_language = lang
checker.save
file.save

file = PCS::Model::File.new
file.name = 'slow.c'



submit = PCS::Model::Submit.new
submit.file = file
submit.task = task;
submit.user = user;
submit.program_language = lang
submit.save
file.save

test_file = PCS::Model::TestFile.new
test_file.test_type = 1

test_file2 = PCS::Model::TestFile.new
test_file2.test_type = 2


file = PCS::Model::File.new
file.name = 'slow.00.in'
test_file.file = file


file2 = PCS::Model::File.new
file2.name = 'slow.00.sol'

test_file2.file = file2

test = PCS::Model::Test.new
test.number = 0
test.task = task

test_file.test = test
test_file2.test = test
test_file.save!
test_file2.save!


module_file = PCS::Model::ModuleFile.new
module_file.module_type = 4

module_file2 = PCS::Model::ModuleFile.new
module_file2.module_type = 5

file = PCS::Model::File.new
file.name = 'module.cpp'
module_file.file = file


file2 = PCS::Model::File.new
file2.name = 'module.h'
module_file2.file = file2

modul = PCS::Model::Module.new
modul.name = 'shit'
modul.task = task
module_file.modul = modul
module_file2.modul = modul
module_file.save!
module_file2.save!

#modul.save
#task.save
#file.save
#file1.save
puts "Test Data added to database succesfully"
