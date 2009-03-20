class PatientsController < ApplicationController
  in_place_edit_for :vcard, :family_name
  in_place_edit_for :vcard, :given_name
  in_place_edit_for :vcard, :street_address
  in_place_edit_for :vcard, :postal_code
  in_place_edit_for :vcard, :locality
  in_place_edit_for :patient, :birth_date
  in_place_edit_for :patient, :doctor_patient_nr
  in_place_edit_for :patient, :insurance_nr
                
  # CRUD Actions
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]
    query ||= params[:quick_search][:query] if params[:quick_search]

    @patients = Patient.clever_find(query)
    respond_to do |format|
      format.html {
        render :action => 'list'
        return
      }
      format.js {
        render :update do |page|
          page.replace_html 'search_results', :partial => 'list'
        end
      }
    end
  end

  def search
    query = params[:query] || params[:search]
    query ||= params[:search][:query] if params[:search]
    query ||= params[:quick_search][:query] if params[:quick_search]
    @patients = Patient.clever_find(query)

    render :partial => 'list', :layout => false
  end

  # GET /posts/new
  def new
    patient = params[:patient]
    @patient = Patient.new(patient)
    @patient.vcard = Vcards::Vcard.new(params[:patient])
    
  end

  # POST /posts
  def create
    @patient = Patient.new
    @patient.vcard = Vcards::Vcard.new

    if @patient.update_attributes(params[:patient]) and @patient.vcard.save
      flash[:notice] = 'Patient erfasst.'
      redirect_to :action => :show, :id => @patient
    else
      render :action => :new
    end
  end

  # GET /patients/1/edit
  def edit
    @patient = Patient.find(params[:id])
  end

  # PUT /patients/1
  def update
    @patient = Patient.find(params[:id])

    respond_to do |format|
      if @patient.update_attributes(params[:patient]) and @patient.vcard.save
        flash[:notice] = 'Patient wurde geändert.'
        format.html { redirect_to(@patient) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # GET /patients/1
  def show
    # TODO: Check if .exists? recognizes the finder conditions
    unless Patient.exists?(params[:id])
      render :inline => "<h1>Patient existiert nicht</h1>", :layout => 'application', :status => 404
      return
    end
    
    @patient = Patient.find(params[:id])
    @service_record = ServiceRecord.new
  end

  # Services
  def list_services
    @patient = Patient.find(params[:id])
    render :partial => 'tariff_items/list', :locals => {:items => @patient.service_records}
  end

  def delete_service
    ServiceRecord.destroy(params[:id])
    redirect_to :action => 'list_services'
  end
end
