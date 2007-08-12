require File.dirname(__FILE__) + '/../../test_helper'
require 'user/contest_controller'

# Re-raise errors caught by the controller.
class User::ContestController; def rescue_action(e) raise e end; end

class User::ContestControllerTest < Test::Unit::TestCase
  def setup
    @controller = User::ContestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
