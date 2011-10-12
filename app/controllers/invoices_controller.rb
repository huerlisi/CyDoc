class InvoicesController < ApplicationController
  # TODO: is duplicated in Patients and Treatment controllers

  in_place_edit_for :session, :date
  in_place_edit_for :service_record, :ref_code
  in_place_edit_for :service_record, :quantity

  in_place_edit_for :invoice, :due_date

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
    
    @invoice.print(@printers[:trays][:plain], @printers[:trays][:invoice])
    
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
    
    @invoice.print_reminder(@printers[:trays][:invoice])
    
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
      format.pdf {
        document = @invoice.insurance_recipe_to_pdf

        send_data document, :filename => "#{@invoice.id}.pdf",
                            :type => "application/pdf",
                            :disposition => 'inline'
      }
    end
  end

  # GET /invoices/1/patient_letter
  def patient_letter
    @invoice ||= Invoice.find(params[:id])
    @patient = @invoice.patient

    respond_to do |format|
      format.html {}
      format.pdf {
        document = @invoice.patient_letter_to_pdf

        send_data document, :filename => "#{@invoice.id}.pdf",
                            :type => "application/pdf",
                            :disposition => 'inline'
      }
    end
  end

  # GET /invoices/1/reminder
  def reminder
    @invoice ||= Invoice.find(params[:id])
    @patient = @invoice.patient

    respond_to do |format|
      format.html {}
      format.pdf {
        document = @invoice.reminder_letter_to_pdf
        
        send_data document, :filename => "#{@invoice.id}.pdf", 
                            :type => "application/pdf",
                            :disposition => 'inline'
      }
    end
  end

  # GET /invoices
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]
    query ||= params[:quick_search][:query] if params[:quick_search]

    @invoices = Invoice.clever_find(query).paginate(:page => params['page'], :per_page => 30, :order => 'id DESC')
    @overdue = Invoice.overdue.paginate(:page => params['page'], :per_page => 30, :order => 'state DESC, id DESC')
    @prepared = Invoice.prepared.paginate(:page => params['page'], :per_page => 30, :order => 'id DESC')
    @treatments = Treatment.open.paginate(:page => params['page'], :per_page => 30, :include => {:patient => {:vcards => :addresses, :vcard => :addresses}, :law => [], :sessions => []})
    
    respond_to do |format|
      format.html {
        render :action => 'list'
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
    @treatment = @invoice.treatment

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
          page.call(:initBehaviour)
          page['invoice_value_date'].select
        end
      }
    end
  end

  # POST /invoices
  def create
    @treatment = Treatment.find(params[:treatment_id])
    @patient = @treatment.patient
    @invoice = Invoice.create_from_treatment(@treatment, params[:invoice][:value_date], params[:tiers][:name], Doctor.find(Thread.current["doctor_id"]), Doctor.find(Thread.current["doctor_id"]))
    
    # Saving
    if @invoice.valid?
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
            page.call(:initBehaviour)
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
