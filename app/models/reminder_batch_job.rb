# -*- encoding : utf-8 -*-
class ReminderBatchJob < InvoiceBatchJob
  attr_accessible :print_insurance_recipe

  def print_insurance_recipe
    self[:print_insurance_recipe] || Tenant.settings['invoices.reminders.print_insurance_recipe']
  end

  def to_s
    "Mahnlauf vom #{created_at.to_date}"
  end

  # Action
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

  def print(printer, insurance_recipe_printer = nil)
    clean_failed_invoice_jobs

    invoices.each do |invoice|
      begin
        invoice.print_reminder(printer, insurance_recipe_printer)
      rescue RuntimeError => e
        failed_jobs << {:invoice_id => invoice.id, :message => e.message }
      end
    end
  end
end
