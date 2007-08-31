class AddMoreData < ActiveRecord::Migration
  def self.up
    lang = PCS::Model::ProgramLanguage.create(:name => "C++")
    lang2 = PCS::Model::ProgramLanguage.create(:name => "C")
    PCS::Model::CompilerOption.create(:command_line => "g++ -O2 -static -I#INCLUDE_PATH# -o #DESTINATION# #SOURCES#",
                                      :program_language => lang,
                                      :time_limit => 10000)
    PCS::Model::CompilerOption.create(:command_line => "gcc -O2 -static -I#INCLUDE_PATH# -o #DESTINATION# #SOURCES#",
                                      :program_language => lang2,
                                      :time_limit => 10000)
  end

  def self.down
    PCS::Model::CompilerOption.destroy_all
    PCS::Model::ProgramLanguage.destroy_all
  end
end
