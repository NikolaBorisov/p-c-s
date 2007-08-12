require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/task_controller'

# Re-raise errors caught by the controller.
class Admin::TaskController; def rescue_action(e) raise e end; end

class Admin::TaskControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::TaskController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
