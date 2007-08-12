require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/grading_queue_controller'

# Re-raise errors caught by the controller.
class Admin::GradingQueueController; def rescue_action(e) raise e end; end

class Admin::GradingQueueControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::GradingQueueController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
