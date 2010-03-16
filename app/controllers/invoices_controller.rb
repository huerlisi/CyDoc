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
          page.replace_html "sub-tab-content-invoices-#{@invoice.id}", :partial => 'show'
          page.replace "invoice_#{@invoice.id}_flash", :partial => 'reminded_flash'
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
    @treatments = Treatment.open.paginate(:page => params['page'], :per_page => 20)
    
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
        redirect_to :controller => :patients, :action => :show, :id => @invoice.patient.id, :tab => 'invoices', :sub_tab => "invoices_#{@invoice.id}"
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
    
    # Sessions
    sessions = @treatment.sessions.open
    
    @invoice.service_records = sessions.collect{|s| s.service_records}.flatten

    # Saving
    if @invoice.save
      for session in sessions
        session.invoice = @invoice
        session.charge!
      end

      flash[:notice] = 'Erfolgreich erstellt.'

      respond_to do |format|
        format.html { redirect_to @invoice }
        format.js {
          render :update do |page|
            page.remove 'invoice_form'
            page.insert_html :bottom, 'sub-tab-content-invoices', :partial => 'shared/sub_tab_content', :locals => {:type => 'invoices', :tab => @invoice, :selected_tab => @invoice}
            page.insert_html :top, 'sub-tab-sidebar-invoices', :partial => 'shared/sub_tab_sidebar_item', :locals => {:type => 'invoices', :tab => @invoice, :selected_tab => @invoice}
            page.call 'showSubTab', "invoices-#{@invoice.id}", "invoices"
            page.replace "invoice_#{@invoice.id}_flash", :partial => 'created_flash'
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

  # DELETE /invoices/1
  def destroy
    @invoice = Invoice.find(params[:id])
    @treatment = @invoice.treatment
    
    @invoice.cancel
    @invoice.save(false)
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          if params[:context] == "list"
            page.replace "invoice_#{@invoice.id}", :partial => 'item', :object => @invoice
          else
            page.replace "sub-tab-content-invoices-#{@invoice.id}", :partial => 'show'
          end
        end
      }
    end
  end
end
