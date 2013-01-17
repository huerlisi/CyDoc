# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper'

class PatientsControllerTest < ActionController::TestCase
  def test_list
    get :list
    assert_response :success
  end
  
  def test_index
    get :index
    assert_response :redirect
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_search
    # No match
    xml_http_request :post, :search, {:patient => {:birth_date => '1.1.2000'}}
    assert_response :success
    assert_select ".search_result", false
  end

  def test_search_date
    xml_http_request :post, :search, {:patient => {:birth_date => '3.2.1990'}}
    assert_response :success
    assert_select ".search_result", 1
    assert_select "#search_result_patient_#{patients(:joe).id}", 1

    xml_http_request :post, :search, {:patient => {:birth_date => '3.2.90'}}
    assert_response :success
    assert_select ".search_result", 1
    assert_select "#search_result_patient_#{patients(:joe).id}", 1

    xml_http_request :post, :search, {:patient => {:birth_date => '4.2.01'}}
    assert_response :success
    assert_select ".search_result", 2
    assert_select "#search_result_patient_#{patients(:young_one).id}", 1
    assert_select "#search_result_patient_#{patients(:old_two).id}", 1

    xml_http_request :post, :search, {:patient => {:name => '', :birth_date => '6.2.80'}}
    assert_response :success
    assert_select ".search_result", 2
    assert_select "#search_result_patient_#{patients(:twin_one).id}", 1
    assert_select "#search_result_patient_#{patients(:twin_two).id}", 1
  end

  def test_search_by_name
    xml_http_request :post, :search, {:patient => {:name => 'Doe', :birth_date => ''}}
    assert_response :success
    assert_select ".search_result", 2
    assert_select "#search_result_patient_#{patients(:us_patient).id}", 1
    assert_select "#search_result_patient_#{patients(:simple_patient).id}", 1
    assert_select "#search_result_patient_#{patients(:joe).id}", 0
  end

  def test_show
    get :show, :id => patients(:simple_patient).id
    assert_response :success

    # Return 404, but nice error if not found
    get :show, :id => 777
    assert_response :missing

    get :show, :id => patients(:joe).id
    assert_response :success

#    get :show, :id => patients(:no_vcard).id
#    assert_response :success
  end
end
