# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper'

class MailingsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :redirect
  end

  def test_latest_overview
    get :latest_overview
    assert_response :success
  end

  def test_list
    get :list
    assert_response :success
  end
end
