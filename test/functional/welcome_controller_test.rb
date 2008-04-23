require File.dirname(__FILE__) + '/../test_helper'

class WelcomeControllerTest < ActionController::TestCase
  set_fixture_class :vcards => "Vcards::Vcard"

  def test_index
    get :index
    assert_response :success
  end
end
