require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # Replace this with your real tests.
  fixtures :users, :countries
  
  def test_truth
    assert true
  end
  
  def test_invalid_with_empty_attributes
    u = PCS::Model::User.new
    
    assert !u.valid?
    assert u.errors.invalid?(:first_name)
    assert u.errors.invalid?(:last_name)
    assert u.errors.invalid?(:username)
    assert u.errors.invalid?(:text_password)
    assert u.errors.invalid?(:text_password_confirmation)
    assert u.errors.invalid?(:city)
    assert u.errors.invalid?(:email)
  end
  
  def test_create
    size = PCS::Model::User.find(:all).size
    u = PCS::Model::User.new(:username                    => "test_user", 
                             :text_password               => "hitra_parola",
                             :text_password_confirmation  => "hitra_parola",
                             :first_name                  => "Petyr",
                             :last_name                   => "Ivanov",
                             :email                       => "p@google.com",
                             :city                        => "Peoria",
                             :address                     => "",
                             :school                      => "",
                             :telephone                   => ""
                             )
    u.country = PCS::Model::Country.find(:first)
    assert_valid u
    assert u.save
    assert_equal(size+1, PCS::Model::User.find(:all).size)
  end
  
  def test_valid_delete
    size = PCS::Model::User.find(:all).size
    u = PCS::Model::User.find(:first)
    assert_equal(PCS::Model::User, u.class)
    assert(u.destroy, "Destroy fails")
    assert_equal(size-1, PCS::Model::User.find(:all).size, "Number of records in the user table should decrease with 1")
  end
  
  
end