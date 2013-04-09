# -*- encoding : utf-8 -*-
class ReminderBatchJob < InvoiceBatchJob
  def to_s
    "Mahnlauf vom #{created_at.to_date}"
  end

  def remind
    for invoice in invoices
      begin
        invoice.remind
        invoice.save!
      rescue RuntimeError => e
        failed_jobs << {:invoice_id => invoice.id, :message => e.message }
      end
    end
  end

  def print(printer)
    clean_failed_invoice_jobs

    invoices.each do |invoice|
      begin
        invoice.print_reminder(printer)
      rescue RuntimeError => e
        failed_jobs << {:invoice_id => invoice.id, :message => e.message }
      end
    end
  end
end
