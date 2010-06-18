class InvoicesController < ApplicationController
  in_place_edit_for :invoice, :due_date

  print_action_for :insurance_recipe, :tray => :plain
  print_action_for :patient_letter, :tray => :invoice
  print_action_for :reminder, :tray => :invoice

  # POST /invoice/1/print
  def print
    @invoice = Invoice.find(params[:id])
    @treatment = @invoice.treatment
    @patient = @treatment.patient
    
    if @invoice.state == "prepared" and !params[:print_copy]
      @invoice.state = 'printed'
      @invoice.save!
    end
    
    print_patient_letter
    print_insurance_recipe
    
    respond_to do |format|
      format.html { redirect_to invoices_path }
      format.js {
        render :update do |page|
          page.replace_html "tab-content-invoices", :partial => 'show'
          page.replace "invoice_flash", :partial => 'printed_flash'
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

  # POST /invoices/1/print_reminder_letter
  def print_reminder_letter
    @invoice = Invoice.find(params[:id])
    @treatment = @invoice.treatment
    @patient = @treatment.patient
    
    unless params[:print_copy]
      @invoice.remind
      @invoice.save!
    end
    
    print_reminder
    
    respond_to do |format|
      format.html { redirect_to invoices_path }
      format.js {
        render :update do |page|
          page.replace_html "tab-content-invoices", :partial => 'show'
          page.replace "invoice_flash", :partial => 'reminded_flash'
        end
      }
    end
  end
  
  # POST /invoices/print_reminder_for_all
  def print_reminders_for_all
    @invoices = Invoice.overdue
    
    for @invoice in @invoices
      @invoice.remind
      @invoice.save!

      print_reminder
    end

    respond_to do |format|
      format.html { redirect_to invoices_path }
      format.js {
        render :update do |page|
          page.remove "overdue_invoice_list"
          page.replace "invoice_list_flash", :partial => 'all_reminded_flash'
        end
       }
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

  # GET /invoices/1/reminder
  def reminder
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

    @invoices = Invoice.clever_find(query).paginate(:page => params['page'], :per_page => 20, :order => 'id DESC')
    @treatments = Treatment.open.paginate(:page => params['page'], :per_page => 20, :include => {:patient => {:vcards => :addresses, :vcard => :addresses}, :law => [], :sessions => []})
    
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
  # GET /patients/1/invoices/2
  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html {
        redirect_to :controller => :patients, :action => :show, :id => @invoice.patient.id, :tab => 'invoices', :sub_tab_id => @invoice.id
      }
      format.js {
        render :update do |page|
          page.replace_html "tab-content-invoices", :partial => 'show'
          page.call 'showTab', controller_name
        end
      }
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @invoice.date = Date.today
    @patient = Patient.find(params[:patient_id])
    @treatment = Treatment.find(params[:treatment_id])
    
    @invoice.treatment = @treatment
    
    # Sessions
    sessions = @treatment.sessions.open
    @invoice.service_records = sessions.collect{|s| s.service_records}.flatten

    @invoice.valid?
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'tab-content-invoices', :partial => 'form'
          page.call 'showTab', "invoices"
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
    # TODO: check if given tiers name is a subclass of Tiers
    @tiers = Object.const_get(params[:tiers][:name]).new
    @tiers.patient = @patient
    @tiers.biller = Doctor.find(Thread.current["doctor_id"])
    @tiers.provider = Doctor.find(Thread.current["doctor_id"])

    @invoice.tiers = @tiers

    # Law
    @invoice.law = @treatment.law
    @invoice.treatment = @treatment
    
    # Sessions
    sessions = @treatment.sessions.open
    @invoice.service_records = sessions.collect{|s| s.service_records}.flatten

    # Check if invoice is valid as assigning it to sessions saves it
    result = @invoice.valid? && Invoice.transaction do
      for session in sessions
        session.invoices << @invoice
        session.charge
        # Touch session as it won't autosave otherwise
        session.touch
      end

      @invoice.book

      @invoice.save
    end
    
    # Saving
    if result
      flash[:notice] = 'Erfolgreich erstellt.'

      respond_to do |format|
        format.html { redirect_to @invoice }
        format.js {
          render :update do |page|
            page.replace_html 'tab-content-invoices', :partial => 'show'
            page.replace_html 'patient-sidebar', :partial => 'patients/sidebar'
            page.call 'showTab', "invoices"
            page.replace "invoice_flash", :partial => 'created_flash'
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace_html 'tab-content-invoices', :partial => 'form'
            page['invoice_value_date'].select
          end
        }
      end
    end
  end

  # DELETE /invoices/1
  def destroy
    @invoice = Invoice.find(params[:id])
    @treatment = @invoice.treatment
    @patient = @invoice.patient
    
    @invoice.cancel
    # Allow saving without validation as validation problem could be a reason to cancel
    @invoice.save(false)
    @treatment.reload
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          if params[:context] == "list"
            page.replace "invoice_#{@invoice.id}", :partial => 'item', :object => @invoice
          else
            page.replace_html "tab-content-invoices", :partial => 'show'
            page.replace_html 'patient-sidebar', :partial => 'patients/sidebar'
          end
        end
      }
    end
  end

  # POST /invoices/1/reactivate
  def reactivate
    @invoice = Invoice.find(params[:id])
    @treatment = @invoice.treatment
    @patient = @invoice.patient
    
    @invoice.reactivate
    # Allow saving without validation as validation problem could be a reason to reactivate
    @invoice.save(false)
    
    @treatment.reload

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          if params[:context] == "list"
            page.replace "invoice_#{@invoice.id}", :partial => 'item', :object => @invoice
          else
            page.replace_html "tab-content-invoices", :partial => 'show'
            page.replace_html "tab-content-treatments", :partial => 'treatments/show'
            page.replace_html 'patient-sidebar', :partial => 'patients/sidebar'
            page.call 'showTab', 'treatments'
          end
        end
      }
    end
  end
end
