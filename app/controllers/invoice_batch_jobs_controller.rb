# -*- encoding : utf-8 -*-
class InvoiceBatchJobsController < AuthorizedController
  defaults :resource_class => InvoiceBatchJob

  # GET /invoice_batch_jobs/new
  def new
    @invoice_batch_job = InvoiceBatchJob.new

    @invoice_batch_job.tiers_name = "TiersGarant"
    @invoice_batch_job.count = Treatment.active.count
    @invoice_batch_job.value_date = Date.today
  end

  # POST /invoice_batch_jobs
  def create
    @invoice_batch_job = InvoiceBatchJob.new(params[:invoice_batch_job])
    @treatments = Treatment.active.all(:limit => @invoice_batch_job.count)

    value_date = @invoice_batch_job.value_date
    tiers_name = @invoice_batch_job.tiers_name
    begin
      biller = Employee.find(current_tenant.settings['invoices.defaults.biller_id'])
      provider = Employee.find(current_tenant.settings['invoices.defaults.provider_id'])
    rescue
      # TODO
      raise "Standart Leistungserbringer oder Rechnungssteller in Mandant nicht gesetzt"
    end

    @invoice_batch_job.create_invoices(@treatments, value_date, tiers_name, provider, biller)
    if current_tenant.settings['printing.cups']
      begin
        patient_letter_printer = current_tenant.printer_for(:invoice)
        insurance_recipe_printer = current_tenant.printer_for(:plain)

        @invoice_batch_job.print(patient_letter_printer, insurance_recipe_printer)
        flash[:notice] = "#{@invoice_batch_job} an Drucker gesendet"

      rescue RuntimeError => e
        flash[:alert] = "Drucken fehlgeschlagen: #{e.message}"
      end
    end

    create!
  end

  # POST /invoice_batch_jobs/1/redo
  def reprint
    @invoice_batch_job = InvoiceBatchJob.find(params[:id])

    if current_tenant.settings['printing.cups']
      begin
        patient_letter_printer = current_tenant.printer_for(:invoice)
        insurance_recipe_printer = current_tenant.printer_for(:plain)

        @invoice_batch_job.print(patient_letter_printer, insurance_recipe_printer)
        flash[:notice] = "#{@invoice_batch_job} an Drucker gesendet"

      rescue RuntimeError => e
        flash[:alert] = "Drucken fehlgeschlagen: #{e.message}"
      end
    end

    @invoice_batch_job.save

    redirect_to @invoice_batch_job
  end
end
