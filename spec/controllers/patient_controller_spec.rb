# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'
  
describe PatientsController do
  fixtures :patients

  before( :each ) do
    controller.stub!( :login_required )
  end
              
  it 'allows patient creation' do
    lambda do
      create_patient
    end.should change(Patient, :count).by(1)
  end

  it 'creates patient in active state' do
    create_patient
    assigns(:patient).reload
    assigns(:patient).should be_active
  end

  it 'creates patient with no dunning stop' do
    create_patient
    assigns(:patient).reload
    assigns(:patient).should_not be_dunning_stop
  end

  def create_patient(options = {})
    post :create, :patient => { }.merge(options)
  end
end

describe PatientsController do
  describe "route generation" do
    it "should route patients's 'index' action correctly" do
      route_for(:controller => 'patients', :action => 'index').should == "/patients"
    end
    
    it "should route {:controller => 'patients', :action => 'create'} correctly" do
      route_for(:controller => 'patients', :action => 'create').should == "/patients"
    end
    
    it "should route patients's 'show' action correctly" do
      route_for(:controller => 'patients', :action => 'show', :id => '1').should == "/patients/1"
    end
    
    it "should route patients's 'edit' action correctly" do
      route_for(:controller => 'patients', :action => 'edit', :id => '1').should == "/patients/1/edit"
    end
    
    it "should route patients's 'update' action correctly" do
      route_for(:controller => 'patients', :action => 'update', :id => '1').should == "/patients/1"
    end
    
    it "should route patients's 'destroy' action correctly" do
      route_for(:controller => 'patients', :action => 'destroy', :id => '1').should == "/patients/1"
    end
  end
  
  describe "route recognition" do
    it "should generate params for patients's index action from GET /patients" do
      params_from(:get, '/patients').should == {:controller => 'patients', :action => 'index'}
      params_from(:get, '/patients.xml').should == {:controller => 'patients', :action => 'index', :format => 'xml'}
      params_from(:get, '/patients.json').should == {:controller => 'patients', :action => 'index', :format => 'json'}
    end
    
    it "should generate params for patients's new action from GET /patients" do
      params_from(:get, '/patients/new').should == {:controller => 'patients', :action => 'new'}
      params_from(:get, '/patients/new.xml').should == {:controller => 'patients', :action => 'new', :format => 'xml'}
      params_from(:get, '/patients/new.json').should == {:controller => 'patients', :action => 'new', :format => 'json'}
    end
    
    it "should generate params for patients's create action from POST /patients" do
      params_from(:post, '/patients').should == {:controller => 'patients', :action => 'create'}
      params_from(:post, '/patients.xml').should == {:controller => 'patients', :action => 'create', :format => 'xml'}
      params_from(:post, '/patients.json').should == {:controller => 'patients', :action => 'create', :format => 'json'}
    end
    
    it "should generate params for patients's show action from GET /patients/1" do
      params_from(:get , '/patients/1').should == {:controller => 'patients', :action => 'show', :id => '1'}
      params_from(:get , '/patients/1.xml').should == {:controller => 'patients', :action => 'show', :id => '1', :format => 'xml'}
      params_from(:get , '/patients/1.json').should == {:controller => 'patients', :action => 'show', :id => '1', :format => 'json'}
    end
    
    it "should generate params for patients's edit action from GET /patients/1/edit" do
      params_from(:get , '/patients/1/edit').should == {:controller => 'patients', :action => 'edit', :id => '1'}
    end
    
    it "should generate params {:controller => 'patients', :action => update', :id => '1'} from PUT /patients/1" do
      params_from(:put , '/patients/1').should == {:controller => 'patients', :action => 'update', :id => '1'}
      params_from(:put , '/patients/1.xml').should == {:controller => 'patients', :action => 'update', :id => '1', :format => 'xml'}
      params_from(:put , '/patients/1.json').should == {:controller => 'patients', :action => 'update', :id => '1', :format => 'json'}
    end
    
    it "should generate params for patients's destroy action from DELETE /patients/1" do
      params_from(:delete, '/patients/1').should == {:controller => 'patients', :action => 'destroy', :id => '1'}
      params_from(:delete, '/patients/1.xml').should == {:controller => 'patients', :action => 'destroy', :id => '1', :format => 'xml'}
      params_from(:delete, '/patients/1.json').should == {:controller => 'patients', :action => 'destroy', :id => '1', :format => 'json'}
    end
  end
  
  describe "named routing" do
    before(:each) do
      get :new
    end
    
    it "should route patients_path() to /patients" do
      patients_path().should == "/patients"
      formatted_patients_path(:format => 'xml').should == "/patients.xml"
      formatted_patients_path(:format => 'json').should == "/patients.json"
    end
    
    it "should route new_patient_path() to /patients/new" do
      new_patient_path().should == "/patients/new"
      formatted_new_patient_path(:format => 'xml').should == "/patients/new.xml"
      formatted_new_patient_path(:format => 'json').should == "/patients/new.json"
    end
    
    it "should route patient_(:id => '1') to /patients/1" do
      patient_path(:id => '1').should == "/patients/1"
      formatted_patient_path(:id => '1', :format => 'xml').should == "/patients/1.xml"
      formatted_patient_path(:id => '1', :format => 'json').should == "/patients/1.json"
    end
    
    it "should route edit_patient_path(:id => '1') to /patients/1/edit" do
      edit_patient_path(:id => '1').should == "/patients/1/edit"
    end
  end
  
end
