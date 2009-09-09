class PatientsController < ApplicationController
  in_place_edit_for :vcard, :family_name
  in_place_edit_for :vcard, :given_name
  in_place_edit_for :vcard, :street_address
  in_place_edit_for :vcard, :postal_code
  in_place_edit_for :vcard, :locality
  in_place_edit_for :patient, :birth_date
  in_place_edit_for :patient, :doctor_patient_nr
  in_place_edit_for :patient, :insurance_nr

  in_place_edit_for :phone_number, :phone_number_type
  in_place_edit_for :phone_number, :number

  in_place_edit_for :session, :date
  # TODO: is duplicated in ServiceRecordsController
  in_place_edit_for :service_record, :ref_code
  in_place_edit_for :service_record, :quantity
                
  in_place_edit_for :invoice, :due_date

  # GET /patients
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]
    query ||= params[:quick_search][:query] if params[:quick_search]

    @patients = Patient.clever_find(query).paginate(:page => params['page'])

    # Show selection list only if more than one hit
    respond_to do |format|
      format.html {
        if @patients.size == 1
          redirect_to :action => :show, :id => @patients.first.id
        else
          render :action => 'list'
        end
        return
      }
      format.js {
        render :update do |page|
          if @patients.size == 1
            page.redirect_to :action => :show, :id => @patients.first.id
          else
            page.replace_html 'search_results', :partial => 'list'
          end
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
    @patient = Patient.new(params[:patient])
    @patient.vcard = Vcards::Vcard.new(params[:patient])

    @patient.doctor_patient_nr = Patient.maximum('CAST(doctor_patient_nr AS UNSIGNED INTEGER)').to_i + 1

    # TODO: probably doctor specific...
    @patient.sex = 'F'
    
    @patient.phone_numbers.build(:phone_number_type => 'Tel. privat')
    @patient.phone_numbers.build(:phone_number_type => 'Tel. geschäft')
    @patient.phone_numbers.build(:phone_number_type => 'Handy')
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
  end

  # POST /patients/1/print_label
  print_action_for :label, :tray => :label, :media => 'Label'
  def label
    @patient = Patient.find(params[:id])
    
    respond_to do |format|
      format.html {}
      format.pdf { render_pdf(:media => 'Label') }
    end
  end

  # POST /patients/1/print_full_label
  print_action_for :full_label, :tray => :label, :media => 'Label'
  def full_label
    @patient = Patient.find(params[:id])
    
    respond_to do |format|
      format.html {}
      format.pdf { render_pdf(:media => 'Label') }
    end
  end
end
