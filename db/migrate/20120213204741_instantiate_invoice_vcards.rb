# -*- encoding : utf-8 -*-
class InstantiateInvoiceVcards < ActiveRecord::Migration
  def self.up
    # Set patient and billing vcards
    ActiveRecord::Base.connection.execute("UPDATE invoices JOIN treatments ON invoices.treatment_id = treatments.id JOIN patients ON patients.id = treatments.patient_id JOIN vcards ON vcards.object_type = 'Patient' AND vcards.object_id = patients.id SET patient_vcard_id = vcards.id WHERE patient_vcard_id IS NULL AND vcards.vcard_type = 'private'")
    ActiveRecord::Base.connection.execute("UPDATE invoices JOIN treatments ON invoices.treatment_id = treatments.id JOIN patients ON patients.id = treatments.patient_id JOIN vcards ON vcards.object_type = 'Patient' AND vcards.object_id = patients.id SET billing_vcard_id = vcards.id WHERE billing_vcard_id IS NULL AND vcards.vcard_type = 'billing'")

    # Use patient vcard as default for billing vcard
    ActiveRecord::Base.connection.execute("UPDATE invoices SET billing_vcard_id = patient_vcard_id WHERE billing_vcard_id IS NULL")
  end
end
