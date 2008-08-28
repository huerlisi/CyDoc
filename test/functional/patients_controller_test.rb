require File.dirname(__FILE__) + '/../test_helper'

class PatientsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_response :success
  end

  def test_search
    # No match
    xml_http_request :post, :search, {:patient => {:birth_date => '1.1.2000'}}
    assert_response :success
    assert_select ".search_result", false

    # Single match
    patient = patients(:joe)

    xml_http_request :post, :search, {:patient => {:birth_date => '3.2.1990'}}
    assert_response :success
    assert_select ".search_result", 1
    assert_select "#search_result_patient_#{patient.id}"
  end
end
