# -*- encoding : utf-8 -*-
class AddMoreIndices < ActiveRecord::Migration
  def self.up
    add_index :drug_articles, :drug_product_id
    add_index :drug_articles, :vat_class_id

    add_index :drug_prices, :drug_article_id
    add_index :drug_prices, :price_type
    
    add_index :esr_records, :esr_file_id
    add_index :esr_records, :booking_id
    add_index :esr_records, :invoice_id

    add_index :insurance_policies, :insurance_id
    add_index :insurance_policies, :patient_id
    add_index :insurance_policies, :policy_type

    add_index :insurances, :ean_party
    add_index :insurances, :group_ean_party
    add_index :insurances, :role

    add_index :invoices, :state
    add_index :invoices, :invoice_replaced_by

    add_index :medical_cases, :patient_id
    add_index :medical_cases, :doctor_id
    add_index :medical_cases, :type
    add_index :medical_cases, :diagnosis_id
    add_index :medical_cases, :treatment_id

    add_index :offices, :login

    add_index :patients, :doctor_patient_nr

    add_index :phone_numbers, :phone_number_type
    add_index :phone_numbers, [:object_id, :object_type]

    add_index :postal_codes, :zip_type
    add_index :postal_codes, :zip

    add_index :service_items, :tariff_item_id
    add_index :service_items, :tariff_item_group_id
    add_index :service_items, :ref_code

    add_index :service_records, :provider_id
    add_index :service_records, :responsible_id
    add_index :service_records, :patient_id
    add_index :service_records, :vat_class_id

    add_index :service_records_sessions, :service_record_id
    add_index :service_records_sessions, :session_id
    
    add_index :sessions, :patient_id
    add_index :sessions, :state
    add_index :sessions, :invoice_id
    add_index :sessions, :treatment_id

    add_index :tariff_items, :code
    add_index :tariff_items, :type
    add_index :tariff_items, :tariff_type
    add_index :tariff_items, :vat_class_id

    add_index :treatments, :referrer_id

    add_index :users, :state
  end

  def self.down
    remove_index :drug_articles, :drug_product_id
    remove_index :drug_articles, :vat_class_id

    remove_index :drug_prices, :drug_article_id
    remove_index :drug_prices, :price_type
    
    remove_index :esr_records, :esr_file_id
    remove_index :esr_records, :booking_id
    remove_index :esr_records, :invoice_id

    remove_index :insurance_policies, :insurance_id
    remove_index :insurance_policies, :patient_id
    remove_index :insurance_policies, :policy_type

    remove_index :insurances, :ean_party
    remove_index :insurances, :group_ean_party
    remove_index :insurances, :role

    remove_index :invoices, :state
    remove_index :invoices, :invoice_replaced_by

    remove_index :medical_cases, :patient_id
    remove_index :medical_cases, :doctor_id
    remove_index :medical_cases, :type
    remove_index :medical_cases, :diagnosis_id
    remove_index :medical_cases, :treatment_id

    remove_index :offices, :login

    remove_index :patients, :doctor_patient_nr

    remove_index :phone_numbers, :phone_number_type
    remove_index :phone_numbers, [:object_id, :object_type]

    remove_index :postal_codes, :zip_type
    remove_index :postal_codes, :zip

    remove_index :service_items, :tariff_item_id
    remove_index :service_items, :tariff_item_group_id
    remove_index :service_items, :ref_code

    remove_index :service_records, :provider_id
    remove_index :service_records, :responsible_id
    remove_index :service_records, :patient_id
    remove_index :service_records, :vat_class_id

    remove_index :service_records_sessions, :service_record_id
    remove_index :service_records_sessions, :session_id
    
    remove_index :sessions, :patient_id
    remove_index :sessions, :state
    remove_index :sessions, :invoice_id
    remove_index :sessions, :treatment_id

    remove_index :tariff_items, :code
    remove_index :tariff_items, :type
    remove_index :tariff_items, :tariff_type
    remove_index :tariff_items, :vat_class_id

    remove_index :treatments, :referrer_id

    remove_index :users, :state
  end
end
