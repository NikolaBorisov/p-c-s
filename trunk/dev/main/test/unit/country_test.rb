require File.dirname(__FILE__) + '/../test_helper'

class CountryTest < Test::Unit::TestCase
  
  fixtures :countries
  
  def test_truth
    assert true
  end
  
  def test_invalid_with_empty_attributes
    c = PCS::Model::Country.new
    assert !c.valid?
    assert c.errors.invalid?(:name)
    assert c.errors.invalid?(:code)
  end
  
  def test_valid_create
    c = PCS::Model::Country.new(:name       => "Albania",
                                :code       => "AL")
    
    assert_valid c
    assert c.save
  end
  
  def test_duplicates
    c = PCS::Model::Country.new(:name       => "Bulgaria",
                                :code       => "BG")
    assert !c.valid?
    assert c.errors.invalid?(:name)
    assert c.errors.invalid?(:code)
  end
  
  def test_delete
    c = PCS::Model::Country.find(1)
    
    assert c.destroy
    assert_equal(1, PCS::Model::Country.find(:all).size)
  end
  
 end