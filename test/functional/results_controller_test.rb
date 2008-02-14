require File.dirname(__FILE__) + '/../test_helper'

class ResultsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success
  end

  def test_list
    get :list
    assert_response :success
  end

  def test_show
    get :show
    assert_response :success
  end
end
