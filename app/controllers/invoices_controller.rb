class InvoicesController < ApplicationController
  # TODO: is duplicated in Patients and Treatment controllers

  in_place_edit_for :session, :date
  in_place_edit_for :service_record, :ref_code
  in_place_edit_for :service_record, :quantity

  in_place_edit_for :invoice, :due_date

  # POST /invoice/1/print
  def print
    @invoice = Invoice.find(params[:id])
    @treatment = @invoice.treatment
    @patient = @treatment.patient
    
    if @invoice.state == "prepared" and !params[:print_copy]
      @invoice.state = 'printed'
      @invoice.save!
    end
    
    if @invoice.settings['printing.cups']
      if @invoice.print(@printers[:trays][:plain], @printers[:trays][:invoice])
        respond_to do |format|
          format.html { redirect_to invoices_path }
          format.js {
            render :update do |page|
              page.replace_html "tab-content-invoices", :partial => 'show'
              page.replace "notice_flash", :partial => 'printed_flash', :locals => {:model => 'invoice'}
            end
          }
        end
      else
        respond_to do |format|
          format.html { redirect_to @invoice }
          format.js {
            render :update do |page|
              page.replace_html "error_flash", :text => @invoice.printing_error
              page.show "error_flash"
              page.hide "notice_flash"
            end
          }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @invoice }
        format.js {
          render :update do |page|
            page.replace_html "tab-content-invoices", :partial => 'show'
            page.replace "notice_flash", :partial => 'pdf_links_flash', :locals => {:views => [:patient_letter, :insurance_recipe]}
          end
        }
      end
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
    
    if @invoice.settings['printing.cups']
      if @invoice.print_reminder(@printers[:trays][:invoice])
        respond_to do |format|
          format.html { redirect_to invoices_path }
          format.js {
            render :update do |page|
              page.replace_html "tab-content-invoices", :partial => 'show'
              page.replace "notice_flash", :partial => 'printed_flash', :locals => {:model => 'reminder'}
            end
          }
        end
      else
        respond_to do |format|
          format.html { redirect_to @invoice }
          format.js {
            render :update do |page|
              page.replace_html "error_flash", :text => @invoice.printing_error
              page.show "error_flash"
              page.hide "notice_flash"
            end
          }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @invoice }
        format.js {
          render :update do |page|
            page.replace_html "tab-content-invoices", :partial => 'show'
            page.replace "notice_flash", :partial => 'pdf_links_flash', :locals => {:views => [:reminder_letter]}
          end
        }
      end
    end
  end
  
  # GET /invoices/1/insurance_recipe
  def insurance_recipe
    @invoice ||= Invoice.find(params[:id])
    @patient = @invoice.patient

    respond_to do |format|
      format.html {}
      format.pdf {
        document = @invoice.document_to_pdf(:insurance_recipe)

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
        document = @invoice.document_to_pdf(:patient_letter)

        send_data document, :filename => "#{@invoice.id}.pdf",
                            :type => "application/pdf",
                            :disposition => 'inline'
      }
    end
  end

  # GET /invoices/1/reminder_letter
  def reminder_letter
    @invoice ||= Invoice.find(params[:id])
    @patient = @invoice.patient

    respond_to do |format|
      format.html {}
      format.pdf {
        document = @invoice.document_to_pdf(:reminder_letter)
        
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

    @invoices = Invoice.clever_find(query).paginate(:page => params['page_search'], :per_page => 30, :order => 'id DESC')
    @overdue = Invoice.overdue(current_user.object.settings['invoices.grace_period']).dunning_active.paginate(:page => params['page_overdue'], :per_page => 30, :order => 'due_date')
    @prepared = Invoice.prepared.paginate(:page => params['page_prepared'], :per_page => 30, :order => 'id DESC')
    @treatments = Treatment.open.paginate(:page => params['page_open'], :per_page => 30, :include => {:patient => {:vcards => :addresses, :vcard => :addresses}, :law => [], :sessions => []})
    
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
    @invoice = Invoice.create_from_treatment(params[:invoice], @treatment, params[:tiers][:name], Doctor.find(Thread.current["doctor_id"]), Doctor.find(Thread.current["doctor_id"]))

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
            page.replace "notice_flash", :partial => 'created_flash'
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
