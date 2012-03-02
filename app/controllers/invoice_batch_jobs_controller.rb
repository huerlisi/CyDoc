class InvoiceBatchJobsController < ApplicationController
  inherit_resources

  # Inherited Resources
  protected
    def collection
      instance_eval("@#{controller_name.pluralize} ||= end_of_association_chain.paginate(:page => params[:page], :per_page => params[:per_page], :order => 'created_at DESC')")
    end

  public

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
        end
      }
    end
  end

  # POST /invoice_batch_jobs
  def create
    @invoice_batch_job = InvoiceBatchJob.new(params[:invoice_batch_job])
    @treatments = Treatment.open.find(:all, :limit => @invoice_batch_job.count)
    
    value_date = @invoice_batch_job.value_date
    tiers_name = @invoice_batch_job.tiers_name
    provider   = Doctor.find(Thread.current["doctor_id"])
    biller     = Doctor.find(Thread.current["doctor_id"])
    
    @invoice_batch_job.create_invoices(@treatments, value_date, tiers_name, provider, biller)
    @invoice_batch_job.print(@printers)

    # Saving
    if @invoice_batch_job.save
      flash[:notice] = 'Erfolgreich erstellt.'

      respond_to do |format|
        format.html { redirect_to @invoice_batch_job }
        format.js {
          render :update do |page|
            page.replace "notice_flash", :partial => 'printed_flash'
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
          end
        }
      end
    end
  end

  # POST /invoice_batch_jobs/1/redo
  def reprint
    @invoice_batch_job = InvoiceBatchJob.find(params[:id])
    
    @invoice_batch_job.print(@printers)
    
    @invoice_batch_job.save
    
    redirect_to @invoice_batch_job
  end
end
