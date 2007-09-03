class AddContestState < ActiveRecord::Migration
  def self.up
    add_column("contests", "status", :string)
  end

  def self.down
    remove_column("contests", "status")
  end
end
