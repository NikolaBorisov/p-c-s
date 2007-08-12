require File.dirname(__FILE__) + '/../test_helper'
require 'pcsadmin_controller'

# Re-raise errors caught by the controller.
class PcsadminController; def rescue_action(e) raise e end; end

class PcsadminControllerTest < Test::Unit::TestCase
  def setup
    @controller = PcsadminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
