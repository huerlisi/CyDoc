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

    @patients = Patient.clever_find(query)
    render :action => 'list'
  end

  def search
    query = params[:query] || params[:search][:query]
    query ||= params[:search][:query] if params[:search]
    @patients = Patient.clever_find(query)

    render :partial => 'list', :layout => false
  end

  def new
    patient = params[:patient]
    @patient = Patient.new(patient)
    @vcard = Vcards::Vcard.new(params[:vcard])
    # TODO: Should be doctor specific preferences, default nothing.
    @vcard.honorific_prefix = 'Frau'
    @vcard.address = Vcards::Address.new

    @patients = []
    render :action => 'list'
  end

  def create
    @patient = Patient.new(params[:patient])
    @vcard = Vcards::Vcard.new(params[:vcard])
    @patient.vcard = @vcard

    if @patient.save
      flash[:notice] = 'Patient erfasst.'
      redirect_to :action => :show, :id => @patient
    else
      render :action => :new
    end
  end

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
