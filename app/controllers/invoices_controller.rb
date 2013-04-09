# -*- encoding : utf-8 -*-
class InvoicesController < AuthorizedController
  # States
  has_scope :invoice_state, :default => proc {|controller| 'booked' if controller.params[:by_text].nil?}, :only => :index
  has_scope :overdue, :type => :boolean

  include I18nHelpers

  # POST /invoice/1/print
  def print
    @invoice = Invoice.find(params[:id])
    @treatment = @invoice.treatment

    if @invoice.state == "prepared" and !params[:print_copy]
      @invoice.state = 'printed'
      @invoice.save!
    end

    if current_tenant.settings['printing.cups']
      begin
        patient_letter_printer = current_tenant.printer_for(:invoice)
        insurance_recipe_printer = current_tenant.printer_for(:plain)

        @invoice.print(patient_letter_printer, insurance_recipe_printer)
        flash.now[:notice] = "#{@invoice} an Drucker gesendet"

      rescue RuntimeError => e
        flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}"
      end

      render 'show_flash'
    else
      respond_to do |format|
        format.html { redirect_to @invoice }
        format.js {
          render 'print', :locals => {:views => [:patient_letter, :insurance_recipe]}
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

    if current_tenant.settings['printing.cups']
      begin
        reminder_printer = current_tenant.printer_for(:invoice)

        @invoice.print_reminder(reminder_printer)
        flash.now[:notice] = "#{@invoice} an Drucker gesendet"

      rescue RuntimeError => e
        flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}"
      end

      render 'show_flash'
    else
      respond_to do |format|
        format.html { redirect_to @invoice }
        format.js {
          render 'print', :locals => {:views => [:reminder_letter]}
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

        send_data document, :filename => @invoice.pdf_name(t_action(:insurance_recipe)),
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

        send_data document, :filename => @invoice.pdf_name,
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

        send_data document, :filename => @invoice.pdf_name(t_action(:reminder_letter)),
                            :type => "application/pdf",
                            :disposition => 'inline'
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
    begin
      @invoice.tiers.biller = Employee.find(current_tenant.settings['invoices.defaults.biller_id'])
    rescue
    end
    begin
      @invoice.tiers.provider = Employee.find(current_tenant.settings['invoices.defaults.provider_id'])
    rescue
    end

    # Sessions
    sessions = @treatment.sessions.active
    @invoice.service_records = sessions.collect{|s| s.service_records}.flatten

    @invoice.valid?
  end

  # POST /invoices
  def create
    @treatment = Treatment.find(params[:treatment_id])
    @patient = @treatment.patient
    @invoice = Invoice.create_from_treatment(params[:invoice], @treatment)

    create!
  end

  # DELETE /invoices/1
  def destroy
    @invoice = Invoice.find(params[:id])
    @treatment = @invoice.treatment
    @patient = @invoice.patient

    @invoice.cancel
    # Allow saving without validation as validation problem could be a reason to cancel
    @invoice.save(:validate => false)
    @treatment.reload

    respond_to do |format|
      format.html {
        redirect_to @invoice
      }
      format.js { }
    end
  end

  # POST /invoices/1/reactivate
  def reactivate
    @invoice = Invoice.find(params[:id])
    @treatment = @invoice.treatment
    @patient = @invoice.patient

    @invoice.reactivate
    # Allow saving without validation as validation problem could be a reason to reactivate
    @invoice.save(:validate => false)
    @treatment.reload

    redirect_to @treatment
  end
end
