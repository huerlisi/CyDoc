require File.dirname(__FILE__) + '/../test_helper'

class ResultsControllerTest < ActionController::TestCase
  set_fixture_class :vcards => "Vcards::Vcard"

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
