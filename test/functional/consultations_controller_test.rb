require File.dirname(__FILE__) + '/../test_helper'

class ConsultationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:consultations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_consultation
    assert_difference('Consultation.count') do
      post :create, :consultation => { }
    end

    assert_redirected_to consultation_path(assigns(:consultation))
  end

  def test_should_show_consultation
    get :show, :id => consultations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => consultations(:one).id
    assert_response :success
  end

  def test_should_update_consultation
    put :update, :id => consultations(:one).id, :consultation => { }
    assert_redirected_to consultation_path(assigns(:consultation))
  end

  def test_should_destroy_consultation
    assert_difference('Consultation.count', -1) do
      delete :destroy, :id => consultations(:one).id
    end

    assert_redirected_to consultations_path
  end
end
