class AddAdminUser < ActiveRecord::Migration
  def self.up
    # Creating admin user with password 'admin'
    user = PCS::Model::User.new
    user.country = PCS::Model::Country.find(:first)
    user.username = "admin"
    user.first_name = "Administrator"
    user.last_name = "Administrator"
    user.city = "Sofia"
    user.email = "admin@admin.com"
    user.text_password = "123456"
    user.text_password_confirmation = "123456"
    user.roles << PCS::Model::Role.find_by_name("admin")
    user.save!

    # Creating contestant user with password 'user'
    user = PCS::Model::User.new
    user.country = PCS::Model::Country.find(:first)
    user.username = "user"
    user.first_name = "Nikola"
    user.last_name = "Borisov"
    user.city = "Sofia"
    user.email = "nikola@borisov.com"
    user.text_password = "123456"
    user.text_password_confirmation = "123456"
    user.roles << PCS::Model::Role.find_by_name("contestant")
    user.save!
  end

  def self.down
    PCS::Model::User.destroy_all
  end
end
