class InvoicesController < ApplicationController
  print_action_for :insurance_recipe, :tray => :plain
  print_action_for :patient_letter, :tray => :invoice

  def print
    @invoice = Invoice.find(params[:id])
    print_patient_letter
    print_insurance_recipe
    
    @invoice.state = 'printed'
    @invoice.save!
    
    respond_to do |format|
      format.html { redirect_to invoices_path }
      format.js { redirect_to invoices_path }
    end
  end
  
  def print_all
    @invoices = Invoice.prepared
    
    for @invoice in @invoices
      print_patient_letter
      print_insurance_recipe
      
      @invoice.state = 'printed'
      @invoice.save!
    end

    respond_to do |format|
      format.html { redirect_to invoices_path }
      format.js { redirect_to invoices_path }
    end
  end

  def insurance_recipe
    @invoice ||= Invoice.find(params[:id])
    @patient = @invoice.patient

    respond_to do |format|
      format.html {}
      format.pdf { render_pdf }
    end
  end

  def patient_letter
    @invoice ||= Invoice.find(params[:id])
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

    if query.blank?
      # TODO: better sorting
      @invoices = Invoice.paginate(:page => params['page'], :order => 'id DESC')
    else
      @invoices = Invoice.clever_find(query).paginate(:page => params['page'], :order => 'id DESC')
    end
    
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
    @treatment = Treatment.find(params[:treatment_id])
    
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
    @treatment = Treatment.find(params[:treatment_id])
    
    # Tiers
    @tiers = Object.const_get(params[:tiers][:name]).new
    @tiers.patient = @patient
    @tiers.biller = Doctor.find(Thread.current["doctor_id"])
    @tiers.provider = Doctor.find(Thread.current["doctor_id"])

    @tiers.save
    @invoice.tiers = @tiers

    # Law
    @invoice.law = @treatment.law
    @invoice.treatment = @treatment
    @invoice.service_records = @treatment.sessions.collect{|s| s.service_records}.flatten

    # Saving
    if @invoice.save
      flash[:notice] = 'Erfolgreich erstellt.'
      redirect_to @invoice
    else
      render :action => 'new'
    end
  end
end
