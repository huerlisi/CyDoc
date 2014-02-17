# -*- encoding : utf-8 -*-
class ReminderBatchJob < InvoiceBatchJob
  attr_accessible :print_insurance_recipe

  def print_insurance_recipe
    self[:print_insurance_recipe] || (Tenant.first.settings['invoices.reminders.print_insurance_recipe'] == "1")
  end

  def to_s
    "Mahnlauf vom #{created_at.try(:to_date)}"
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

  def print(printer, insurance_recipe_printer)
    clean_failed_invoice_jobs

    invoices.each do |invoice|
      begin
        if print_insurance_recipe?
          invoice.print_reminder_with_insurance_recipe(printer, insurance_recipe_printer)
        else
          invoice.print_reminder(printer)
        end
      rescue RuntimeError => e
        failed_jobs << {:invoice_id => invoice.id, :message => e.message }
      end
    end
  end
end
