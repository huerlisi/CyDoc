class InvoiceBatchJobsController < ApplicationController
  # GET /invoice_batch_jobs/new
  def new
    @invoice_batch_job = InvoiceBatchJob.new
    
    @invoice_batch_job.tiers_name = "TiersGarant"
    @invoice_batch_job.count = Treatment.open.count
    @invoice_batch_job.value_date = Date.today
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.insert_html :before, 'open_treatments', :partial => 'form'
          page.call(:initBehaviour)
          page['invoice_batch_job_value_date'].select
        end
      }
    end
  end

  def create
    @invoice_batch_job = InvoiceBatchJob.new(params[:invoice_batch_job])
    @treatments = Treatment.open.find(:all, :limit => @invoice_batch_job.count)
    
    value_date = @invoice_batch_job.value_date
    tiers_name = @invoice_batch_job.tiers_name
    provider   = Doctor.find(Thread.current["doctor_id"])
    biller     = Doctor.find(Thread.current["doctor_id"])
    
    for treatment in @treatments
      # Create invoice
      invoice = Invoice.create_from_treatment(treatment, value_date, tiers_name, provider, biller)

      # Print
      invoice.print(@printers[:trays][:plain], @printers[:trays][:invoice])

      # Record as belonging to this batch
      @invoice_batch_job.invoices << invoice
    end
    
    # Saving
    if true
      flash[:notice] = 'Erfolgreich erstellt.'

      respond_to do |format|
        format.html { redirect_to @invoice }
        format.js {
          render :update do |page|
            page.remove 'invoice_batch_form'
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

end
