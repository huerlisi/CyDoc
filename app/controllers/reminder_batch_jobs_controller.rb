class ReminderBatchJobsController < InvoiceBatchJobsController
  # GET /reminder_batch_jobs/new
  def new
    @reminder_batch_job = ReminderBatchJob.new

    @reminder_batch_job.count = Invoice.overdue(@current_doctor.settings['invoices.grace_period']).dunning_active.count
    @reminder_batch_job.value_date = Date.today

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.insert_html :before, 'overdue_invoice_list', :partial => 'form'
          page.call(:initBehaviour)
        end
      }
    end
  end

  # POST /reminder_batch_jobs
  def create
    @reminder_batch_job = ReminderBatchJob.new(params[:reminder_batch_job])
    @invoices = Invoice.overdue(@current_doctor.settings['invoices.grace_period']).dunning_active.all(:limit => @reminder_batch_job.count)

    @reminder_batch_job.invoices = @invoices
    @reminder_batch_job.remind
    @reminder_batch_job.print(@printers)

    # Saving
    if @reminder_batch_job.save
      flash[:notice] = 'Erfolgreich erstellt.'

      respond_to do |format|
        format.html { redirect_to @reminder_batch_job }
        format.js {
          render :update do |page|
            page.replace "reminder_flash", :partial => 'printed_flash'
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
end
