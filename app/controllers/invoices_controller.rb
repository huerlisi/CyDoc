class InvoicesController < ApplicationController
  print_action_for :insurance_recipe, :tray => :plain
  print_action_for :patient_letter, :tray => :invoice

  def insurance_recipe
    @invoice = Invoice.find(params[:id])
    @patient = @invoice.patient

    respond_to do |format|
      format.html {}
      format.pdf { render_pdf }
    end
  end

  def patient_letter
    @invoice = Invoice.find(params[:id])
    @patient = @invoice.patient

    respond_to do |format|
      format.html {}
      format.pdf { render_pdf }
    end
  end

  # CRUD actions
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]
    query ||= params[:quick_search][:query] if params[:quick_search]

    @invoices = Invoice.clever_find(query)
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

  def show
    @invoice = Invoice.find(params[:id])
    @patient = @invoice.patient
  end

  def new
    @invoice = Invoice.new
    @invoice.date = Date.today
    
    respond_to do |format|
      format.html { }
      format.js {
        render :partial => 'form'
      }
    end
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    @patient = Patient.find(params[:patient_id])
    
    # Tiers
    @tiers = TiersGarant.new(params[:tiers])
    @tiers.patient = @patient
    @tiers.biller = Doctor.find(Thread.current["doctor_id"])
    @tiers.provider = Doctor.find(Thread.current["doctor_id"])

    @tiers.save
    @invoice.tiers = @tiers

    # Law, TODO
    @law = Object.const_get(params[:law][:name]).new
    @law.insured_id = @patient.insurance_nr

    @law.save
    @invoice.law = @law
    
    # Treatment
    @treatment = @invoice.build_treatment(params[:treatment])

    # TODO make selectable
    @treatment.canton ||= @tiers.provider.vcard.address.region

    # Services
    # TODO: only open records
    service_records = @patient.service_records

    @invoice.service_records = service_records
    @treatment.date_begin = service_records.minimum(:date)
    @treatment.date_end = service_records.maximum(:date)

    medical_cases = @patient.medical_cases.find(:all, ["duration_from >= ? OR duration_to <= ?", @treatment.date_begin, @treatment.date_end])
    @treatment.diagnoses = medical_cases.map{|medical_case| medical_case.diagnosis}

    # Saving
    if @invoice.save
      flash[:notice] = 'Erfolgreich erstellt.'
      redirect_to :controller => 'invoices', :action => 'show', :id => @invoice
    else
      render :action => 'new'
    end
  end
end
