class PortBooleanSettings < ActiveRecord::Migration
  def up
    boolean_key = [
      'invoices.reminders.print_insurance_recipe',
      'invoices.print_payment_for',
      'validation.medical_case_present',
      'validation.tarmed',
      'printing.cups',
      'modules.recalls',
      'modules.drugs',
      'modules.returned_invoices',
      'modules.hozr',
      'modules.covercard'
    ]

    ScopedSettings.where(:var => boolean_key).find_each do |setting|
      setting.value = setting.value ? "1" : "0"
      setting.save
    end
  end
end
