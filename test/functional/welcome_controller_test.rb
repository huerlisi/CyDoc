# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper'

class WelcomeControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success
  end
end
