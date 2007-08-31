class AddAdminUser < ActiveRecord::Migration
  def self.up
    # Creating admin user with password 'admin'
    user = PCS::Model::User.new
    user.country = PCS::Model::Country.find(:first)
    user.username = "admin"
    user.password = Digest::SHA1.hexdigest('admin')
    user.roles << PCS::Model::Role.find_by_name("admin")
    user.save

    # Creating contestant user with password 'user'
    user = PCS::Model::User.new
    user.country = PCS::Model::Country.find(:first)
    user.username = "user"
    user.password = Digest::SHA1.hexdigest('user')
    user.roles << PCS::Model::Role.find_by_name("admin")
    user.save
  end

  def self.down
    PCS::Model::User.destroy_all
  end
end
