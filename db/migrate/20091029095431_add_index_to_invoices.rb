# -*- encoding : utf-8 -*-
class AddIndexToInvoices < ActiveRecord::Migration
  def self.up
    add_index :invoices, :tiers_id
    add_index :invoices, :law_id
    add_index :invoices, :treatment_id
    
    add_index :bookings, [:reference_id, :reference_type]
    
    add_index :treatments, :patient_id
    add_index :treatments, :law_id

    add_index :tiers, :biller_id
    add_index :tiers, :provider_id
    add_index :tiers, :insurance_id
    add_index :tiers, :patient_id
    add_index :tiers, :guarantor_id
    add_index :tiers, :referrer_id
    add_index :tiers, :employer_id
  end

  def self.down
    remove_index :invoices, :tiers_id
    remove_index :invoices, :law_id
    remove_index :invoices, :treatment_id

    remove_index :bookings, :column => [:reference_id, :reference_type]
    
    remove_index :treatments, :patient_id
    remove_index :treatments, :law_id

    remove_index :tiers, :biller_id
    remove_index :tiers, :provider_id
    remove_index :tiers, :insurance_id
    remove_index :tiers, :patient_id
    remove_index :tiers, :guarantor_id
    remove_index :tiers, :referrer_id
    remove_index :tiers, :employer_id
  end
end
