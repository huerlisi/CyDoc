require File.dirname(__FILE__) + '/../test_helper'

class MailingsControllerTest < ActionController::TestCase
  fixtures :mailings
  
  def test_index
    get :index
    assert_response :redirect
  end

  def test_list
    get :list
    assert_response :success

    assert_tag :content => 'Alle Resultate drucken', :parent => :a
    assert_tag :content => 'Nur Übersicht drucken', :parent => :a

    assert_tag :content => '0', :parent => { 
      :tag => :a, :attributes => { 
        :href => @controller.url_for(:controller => :mailings, :action => :show, :id => 1)
      }
    }

    assert_tag :content => /Unbekannter Arzt/
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
