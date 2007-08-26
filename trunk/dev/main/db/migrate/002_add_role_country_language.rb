class AddRoleCountryLanguage < ActiveRecord::Migration
  def self.up
    PCS::Model::Language.create(:name => "English", :code => "EN")
    PCS::Model::Country.create(:name => "Bulgaria")
    PCS::Model::Role.create(:name => "contestant")
    PCS::Model::Role.create(:name => "admin")
  end

  def self.down
    PCS::Model::Language.delete_all
    PCS::Model::Country.delete_all
    PCS::Model::Role.delete_all
  end
end
