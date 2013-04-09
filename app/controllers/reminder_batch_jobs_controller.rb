# -*- encoding : utf-8 -*-
class ReminderBatchJobsController < InvoiceBatchJobsController
  defaults :resource_class => ReminderBatchJob

  # GET /reminder_batch_jobs/new
  def new
    @reminder_batch_job = ReminderBatchJob.new

    @reminder_batch_job.count = reminder.overdue.no_grace.dunning_active.count
    @reminder_batch_job.value_date = Date.today
  end

  # POST /reminder_batch_jobs
  def create
    @reminder_batch_job = ReminderBatchJob.new(params[:reminder_batch_job])
    @reminders = reminder.overdue.no_grace.dunning_active.all(:limit => @reminder_batch_job.count)

    @reminder_batch_job.reminders = @reminders
    @reminder_batch_job.remind
    if current_tenant.settings['printing.cups']
      begin
        reminder_printer = current_tenant.printer_for(:invoice)

        @reminder_batch_job.print(reminder_printer)
        flash[:notice] = "#{@reminder_batch_job} an Drucker gesendet"

      rescue RuntimeError => e
        flash[:alert] = "Drucken fehlgeschlagen: #{e.message}"
      end
    end

    create!
  end

  # POST /reminder_batch_jobs/1/redo
  def reprint
    @reminder_batch_job = ReminderBatchJob.find(params[:id])

    if current_tenant.settings['printing.cups']
      begin
        reminder_printer = current_tenant.printer_for(:invoice)

        @reminder_batch_job.print(reminder_printer)
        flash[:notice] = "#{@reminder_batch_job} an Drucker gesendet"

      rescue RuntimeError => e
        flash[:alert] = "Drucken fehlgeschlagen: #{e.message}"
      end
    end

    @reminder_batch_job.save

    redirect_to @reminder_batch_job
  end
end
