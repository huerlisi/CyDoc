# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'
  
include AuthenticatedTestHelper

describe WelcomeController do
  fixtures :users, :doctors

  describe "for anonymous users" do
    it 'should redirect to login page' do
      get :index
      response.should redirect_to('/session/new')
    end
  end

  describe "for logged in test user" do
    before( :each ) do
      login_as :test
    end

    it 'should render index page' do
      get :index
      response.should be_success
      response.should render_template('welcome/index')
    end
  end

  describe "for logged in users" do
    before( :each ) do
      controller.stub!( :login_required )
    end

    it 'should render index page' do
      get :index
      response.should be_success
      response.should render_template('welcome/index')
    end
  end
end

describe WelcomeController do
  describe "route generation" do
    it "should route welcome's 'index' action correctly" do
      route_for(:controller => 'welcome', :action => 'index').should == "/"
    end
  end
  
  describe "route recognition" do
    it "should generate params for welcome's index action from GET /" do
      params_from(:get, '/').should == {:controller => 'welcome', :action => 'index'}
    end
  end
end
