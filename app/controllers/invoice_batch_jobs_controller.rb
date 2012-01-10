class InvoiceBatchJobsController < ApplicationController
  # GET /invoice_batch_jobs
  def index
    @invoice_batch_jobs = InvoiceBatchJob.paginate(:page => params[:page], :order => 'created_at DESC')
  end

  # GET /invoice_batch_jobs/1
  def show
    @invoice_batch_job = InvoiceBatchJob.find(params[:id])
  end

  # GET /invoice_batch_jobs/new
  def new
    @invoice_batch_job = InvoiceBatchJob.new
    
    @invoice_batch_job.tiers_name = "TiersGarant"
    @invoice_batch_job.count = Treatment.open.ready_to_bill(Treatment::GRACE_PERIOD).count
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

  # POST /invoice_batch_jobs
  def create
    @invoice_batch_job = InvoiceBatchJob.new(params[:invoice_batch_job])
    @treatments = Treatment.open.ready_to_bill(Treatment::GRACE_PERIOD).find(:all, :limit => @invoice_batch_job.count)
    
    value_date = @invoice_batch_job.value_date
    tiers_name = @invoice_batch_job.tiers_name
    provider   = Doctor.find(Thread.current["doctor_id"])
    biller     = Doctor.find(Thread.current["doctor_id"])
    
    @invoice_batch_job.failed_jobs = []
    @treatments.each_with_index do |treatment_readonly, index|

      # Sleep for 4min every 50 treatments
      if index > 0 and index.modulo(50) == 0
        sleep 4 * 60
      end

      treatment = Treatment.find(treatment_readonly.id)

      # Create invoice
      invoice = Invoice.create_from_treatment(treatment, value_date, tiers_name, provider, biller)

      if invoice.new_record?
        # Invoice was invalid in some way
        @invoice_batch_job.failed_jobs << {:treatment_id => treatment.id, :message => invoice.errors.full_messages}
      else
        # Print
        begin
          invoice.print(@printers[:trays][:plain], @printers[:trays][:invoice])
        rescue RuntimeError => e
          @invoice_batch_job.failed_jobs << {:invoice_id => invoice.id, :message => e.message }
          next
        end

        # Record as belonging to this batch
        @invoice_batch_job.invoices << invoice
      end
    end
    
    # Saving
    if @invoice_batch_job.save
      flash[:notice] = 'Erfolgreich erstellt.'

      respond_to do |format|
        format.html { redirect_to @invoice_batch_job }
        format.js {
          render :update do |page|
            page.replace "invoice_flash", :partial => 'printed_flash'
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

  # POST /invoice_batch_jobs/1/redo
  def reprint
    @invoice_batch_job = InvoiceBatchJob.find(params[:id])
    
    @invoice_batch_job.failed_jobs = @invoice_batch_job.failed_jobs.reject{|job| job[:invoice_id]}
    for invoice in @invoice_batch_job.invoices
      # Print
      begin
        invoice.print(@printers[:trays][:plain], @printers[:trays][:invoice])
      rescue RuntimeError => e
        @invoice_batch_job.failed_jobs << {:invoice_id => invoice.id, :message => e.message }
        next
      end
    end
    
    @invoice_batch_job.save
    
    redirect_to @invoice_batch_job
  end
end
