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

  def test_overview
    get :overview
    assert_response :success
  end

  def test_statistics
    get :overview
    assert_response :success
  end
end
