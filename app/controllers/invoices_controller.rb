class InvoicesController < ApplicationController
  print_action_for :insurance_recipe, :tray => :plain
  print_action_for :patient_letter, :tray => :invoice

  # POST /invoice/1/print
  def print
    @invoice = Invoice.find(params[:id])
    @treatment = @invoice.treatment
    @patient = @treatment.patient
    
    print_patient_letter
    print_insurance_recipe
    
    unless params[:print_copy]
      @invoice.state = 'printed'
      @invoice.save!
    end
    
    respond_to do |format|
      format.html { redirect_to invoices_path }
      format.js {
        render :update do |page|
          page.replace_html "sub-tab-content-invoices-#{@invoice.id}", :partial => 'show'
          page.replace "invoice_#{@invoice.id}_flash", :partial => 'printed_flash'
        end
      }
    end
  end
  
  # POST /invoices/print_all
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

  # GET /invoices/1/insurance_recipe
  def insurance_recipe
    @invoice ||= Invoice.find(params[:id])
    @patient = @invoice.patient

    respond_to do |format|
      format.html {}
      format.pdf { render_pdf }
    end
  end

  # GET /invoices/1/patient_letter
  def patient_letter
    @invoice ||= Invoice.find(params[:id])
    @patient = @invoice.patient

    respond_to do |format|
      format.html {}
      format.pdf { render_pdf }
    end
  end

  # GET /invoices
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]
    query ||= params[:quick_search][:query] if params[:quick_search]

    if query.blank?
      # TODO: better sorting
      @invoices = Invoice.paginate(:page => params['page'], :per_page => 20, :order => 'id DESC')
    else
      @invoices = Invoice.clever_find(query).paginate(:page => params['page'], :per_page => 20, :order => 'id DESC')
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

  # GET /invoice/1
  def show
    @invoice = Invoice.find(params[:id])

    redirect_to :controller => :patients, :action => :show, :id => @invoice.patient.id, :tab => 'invoices', :sub_tab => "invoices_#{@invoice.id}"
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @invoice.date = Date.today
    @patient = Patient.find(params[:patient_id])
    @treatment = Treatment.find(params[:treatment_id])
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "new_treatment_#{@treatment.id}_invoice", :partial => 'form'
          page['invoice_value_date'].select
        end
      }
    end
  end

  # POST /invoices
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

      respond_to do |format|
        format.html { redirect_to @invoice }
        format.js {
          render :update do |page|
            page.insert_html :bottom, 'tab-content-invoices', :partial => 'shared/sub_tab_content', :locals => {:type => 'invoices', :tab => @invoice, :selected_tab => true}
#            page.call 'showSubTab', "invoices_#{@invoice.id}", "invoices"
            page.replace "invoice_#{@invoice.id}_flash", :partial => 'printed_flash'
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace_html "new_treatment_#{@treatment.id}_invoice", :partial => 'form'
            page['invoice_value_date'].select
          end
        }
      end
    end
  end

  # POST /invcoice/1/book
  def book
    @invoice = Invoice.find(params[:id])
    @treatment = @invoice.treatment
    @patient = @treatment.patient
    
    booking = @invoice.build_booking
    
    if booking.save
      @invoice.state = 'booked'
      @invoice.save
    end
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "sub-tab-content-invoices-#{@invoice.id}", :partial => 'show'
          page.replace "invoice_#{@invoice.id}_flash", :partial => 'booked_flash'
        end
      }
    end
  end

  # DESTROY /invoices/1
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "invoice_#{@invoice.id}"
        end
      }
    end
  end
end
