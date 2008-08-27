require File.dirname(__FILE__) + '/../test_helper'

class MailingsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :redirect
  end

  def test_list
    get :list
    assert_response :success
  end
end
