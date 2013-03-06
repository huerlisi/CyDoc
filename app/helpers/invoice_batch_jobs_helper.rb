# -*- encoding : utf-8 -*-
module InvoiceBatchJobsHelper
  def failed_jobs(invoice_batch_job)
    return unless invoice_batch_job.failed_jobs

    output = ""
    for failed_job in invoice_batch_job.failed_jobs
      output += content_tag 'p' do
        begin
          if failed_job[:invoice_id]
            invoice = Invoice.find(failed_job[:invoice_id])
            link = link_to invoice, invoice
            message = failed_job[:message]
          elsif failed_job[:treatment_id]
            treatment = Treatment.find(failed_job[:treatment_id])
            link = link_to treatment, treatment
            message = failed_job[:message].join(", ")
          end

          link + ": " + message
        rescue
        end
      end
    end

    output.html_safe
  end
end
