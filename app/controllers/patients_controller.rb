class PatientsController < ApplicationController
  in_place_edit_for :vcard, :family_name
  in_place_edit_for :vcard, :given_name
  in_place_edit_for :vcard, :street_address
  in_place_edit_for :vcard, :postal_code
  in_place_edit_for :vcard, :locality
  in_place_edit_for :patient, :birth_date
  in_place_edit_for :patient, :insurance_nr

  in_place_edit_for :phone_number, :phone_number_type
  in_place_edit_for :phone_number, :number

  in_place_edit_for :session, :date
  # TODO: is duplicated in ServiceRecordsController
  in_place_edit_for :service_record, :ref_code
  in_place_edit_for :service_record, :quantity
                
  in_place_edit_for :invoice, :due_date

  def localities_for_postal_code
    render :update do |page|
      localities = PostalCode.find_all_by_zip(params[:postal_code])
      if localities.count == 1
        page.replace 'patient_vcard_attributes_locality', text_field_tag('patient_vcard_attributes_locality', localities[0].locality)
      else
        page.replace 'patient_vcard_attributes_locality', select('patient[vcard_attributes]', 'locality', localities.collect {|p| p.locality })
      end
    end
  end
  
  def postal_codes_for_locality
    render :update do |page|
      postal_codes = PostalCode.find(:all, :conditions => ["locality LIKE CONCAT('%', ?, '%')", params[:locality]])
      if postal_codes.count == 1
        page.replace 'patient_vcard_attributes_postal_code', text_field_tag('patient_vcard_attributes_postal_code', postal_codes[0].zip, :size => 9)
      else
        page.replace 'patient_vcard_attributes_postal_code', select('patient[vcard_attributes]', 'postal_code', postal_codes.collect {|p| ["#{p.zip} - #{p.locality}", p.zip] })
        page['patient_vcard_attributes_postal_code'].focus
      end
    end
  end
  
  # GET /patients
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]
    query ||= params[:quick_search][:query] if params[:quick_search]

    if params[:all]
      @patients = Patient.paginate(:page => params['page'])
    else
      @patients = Patient.clever_find(query).paginate(:page => params['page'])
    end

    # Show selection list only if more than one hit
    respond_to do |format|
      format.html {
        if !params[:all] and @patients.size == 1
          redirect_to :action => :show, :id => @patients.first.id
        else
          render :action => 'list'
        end
        return
      }
      format.js {
        render :update do |page|
          if !params[:all] and @patients.size == 1
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
    @patient.vcard = Vcard.new(params[:patient])

    @patient.doctor_patient_nr = Patient.maximum('CAST(doctor_patient_nr AS UNSIGNED INTEGER)').to_i + 1

    # TODO: probably doctor specific...
    @patient.sex = 'F'
  end

  # POST /posts
  def create
    @patient = Patient.new
    @patient.vcard = Vcard.new

    if @patient.vcard.update_attributes(params[:vcard]) and @patient.update_attributes(params[:patient])
      flash[:notice] = 'Patient erfasst.'
      redirect_to :action => :show, :id => @patient
    else
      render :action => :new
    end
  end

  # GET /patients/1/edit
  def edit
    @patient = Patient.find(params[:id])

    respond_to do |format|
      format.html {}
      format.js {
        render :update do |page|
          page.replace_html "tab-content-personal", :partial => 'edit'
        end
      }
    end
  end

  # PUT /patients/1
  def update
    @patient = Patient.find(params[:id])

    respond_to do |format|
      if @patient.vcard.update_attributes(params[:vcard]) and @patient.update_attributes(params[:patient])
        flash[:notice] = 'Patient wurde geändert.'
        format.html { redirect_to(@patient) }
        format.js {
          render :update do |page|
            page.replace_html "tab-content-personal", :partial => 'show'
          end
        }
      else
        format.html { render :action => "edit" }
        format.js {
          render :update do |page|
            page.replace_html "tab-content-personal", :partial => 'edit'
          end
        }
      end
    end
  end

  # GET /patients/1
  def show
    @patient = Patient.find(params[:id])
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "tab-content-personal", :partial => 'show'
        end
      }
    end
  end

  # GET /patients/1/show_tab
  def show_tab
    respond_to do |format|
      @patient = Patient.find(params[:id])
      
      format.js {
        # For partial updates used in form cancellation events
        if tab = params[:tab]
          render :update do |page|
            page.replace "patient-#{tab}", :partial => tab
          end
        end
      }
    end
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
