class AddContestTypeAndBoardType < ActiveRecord::Migration
  def self.up
    PCS::Model::ContestType.create!(:name => "IOI")
    PCS::Model::BoardType.create!(:name => "IOI")
  end

  def self.down
    PCS::Model::ContestType.destroy_all
    PCS::Model::BoardType.destroy_all
  end
end
