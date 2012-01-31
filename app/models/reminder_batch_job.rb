class ReminderBatchJob < InvoiceBatchJob
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

  def print(printers)
    clean_failed_invoice_jobs

    invoices.each_with_index do |invoice, index|
      # Sleep for 4min every 50 treatments
      if index > 0 and index.modulo(50) == 0
        sleep 4 * 60
      end

      # Print
      begin
        invoice.print_reminder(printers[:trays][:invoice])
      rescue RuntimeError => e
        failed_jobs << {:invoice_id => invoice.id, :message => e.message }
      end
    end
  end
end
