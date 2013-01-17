# -*- encoding : utf-8 -*-
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130116155708) do

  create_table "account_types", :force => true do |t|
    t.string   "name",       :limit => 100
    t.string   "title",      :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_types", ["name"], :name => "index_account_types_on_name"

  create_table "accounts", :force => true do |t|
    t.string   "number"
    t.integer  "bank_id"
    t.string   "esr_id"
    t.string   "pc_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "holder_id"
    t.string   "holder_type"
    t.string   "title"
    t.string   "code"
    t.integer  "parent_id"
    t.integer  "account_type_id"
    t.string   "iban"
  end

  add_index "accounts", ["account_type_id"], :name => "index_accounts_on_account_type_id"
  add_index "accounts", ["bank_id"], :name => "index_accounts_on_bank_id"
  add_index "accounts", ["code"], :name => "index_accounts_on_code"
  add_index "accounts", ["holder_id", "holder_type"], :name => "index_accounts_on_holder_id_and_holder_type"
  add_index "accounts", ["type"], :name => "index_accounts_on_type"

  create_table "addresses", :force => true do |t|
    t.string   "post_office_box",  :limit => 50
    t.string   "extended_address", :limit => 50
    t.string   "street_address",   :limit => 50
    t.string   "locality",         :limit => 50
    t.string   "region",           :limit => 50
    t.string   "postal_code",      :limit => 50
    t.string   "country_name",     :limit => 50
    t.integer  "vcard_id"
    t.string   "address_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["vcard_id"], :name => "addresses_vcard_id_index"

  create_table "appointments", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "recall_id"
    t.integer  "treatment_id"
    t.text     "remarks"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.datetime "duration_from"
    t.datetime "duration_to"
  end

  add_index "appointments", ["patient_id"], :name => "index_appointments_on_patient_id"
  add_index "appointments", ["recall_id"], :name => "index_appointments_on_recall_id"
  add_index "appointments", ["state"], :name => "index_appointments_on_state"
  add_index "appointments", ["treatment_id"], :name => "index_appointments_on_treatment_id"

  create_table "attachments", :force => true do |t|
    t.string   "title"
    t.string   "file"
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["code"], :name => "index_attachments_on_code"
  add_index "attachments", ["object_id", "object_type"], :name => "index_attachments_on_object_id_and_object_type"

  create_table "banks", :force => true do |t|
    t.integer  "vcard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "swift"
    t.string   "clearing"
  end

  add_index "banks", ["vcard_id"], :name => "index_banks_on_vcard_id"

  create_table "bookings", :force => true do |t|
    t.string   "title",             :limit => 100
    t.decimal  "amount",                           :precision => 8, :scale => 2
    t.integer  "credit_account_id"
    t.integer  "debit_account_id"
    t.date     "value_date"
    t.text     "comments"
    t.integer  "reference_id"
    t.string   "reference_type"
    t.integer  "imported_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scan"
    t.string   "debit_currency",                                                 :default => "CHF"
    t.string   "credit_currency",                                                :default => "CHF"
    t.float    "exchange_rate",                                                  :default => 1.0
    t.integer  "template_id"
    t.string   "template_type"
    t.string   "code"
  end

  add_index "bookings", ["credit_account_id"], :name => "index_bookings_on_credit_account_id"
  add_index "bookings", ["debit_account_id"], :name => "index_bookings_on_debit_account_id"
  add_index "bookings", ["reference_id", "reference_type"], :name => "index_bookings_on_reference_id_and_reference_type"
  add_index "bookings", ["template_id", "template_type"], :name => "index_bookings_on_template_id_and_template_type"
  add_index "bookings", ["value_date"], :name => "index_bookings_on_value_date"

  create_table "diagnoses", :force => true do |t|
    t.string   "type"
    t.string   "code"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diagnoses_sessions", :id => false, :force => true do |t|
    t.integer "diagnosis_id"
    t.integer "session_id"
  end

  create_table "diagnoses_treatments", :id => false, :force => true do |t|
    t.integer "diagnosis_id"
    t.integer "treatment_id"
  end

  create_table "doctors", :force => true do |t|
    t.string   "code"
    t.string   "speciality"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                          :default => true
    t.string   "login"
    t.string   "ean_party",         :limit => 13
    t.string   "zsr",               :limit => 7
    t.text     "remarks"
    t.integer  "imported_id"
    t.boolean  "use_vesr"
    t.boolean  "print_payment_for"
    t.integer  "esr_account_id"
  end

  add_index "doctors", ["imported_id"], :name => "index_doctors_on_imported_id"

  create_table "doctors_offices", :id => false, :force => true do |t|
    t.integer "office_id"
    t.integer "doctor_id"
  end

  create_table "drug_articles", :force => true do |t|
    t.string   "code"
    t.string   "group_code"
    t.string   "assort_key1"
    t.string   "assort_key2"
    t.integer  "drug_product_id"
    t.string   "swissmedic_cat"
    t.string   "swissmedic_no"
    t.boolean  "hospital_only"
    t.boolean  "clinical"
    t.string   "article_type"
    t.integer  "vat_class_id"
    t.boolean  "active"
    t.boolean  "insurance_limited"
    t.float    "insurance_limitation_points"
    t.boolean  "grand_frere"
    t.boolean  "stock_fridge"
    t.string   "stock_temperature"
    t.boolean  "narcotic"
    t.boolean  "under_bg"
    t.integer  "expires"
    t.float    "quantity"
    t.text     "description",                 :limit => 255
    t.text     "name"
    t.string   "quantity_unit"
    t.string   "package_type"
    t.string   "multiply"
    t.string   "alias"
    t.boolean  "higher_co_payment"
    t.integer  "number_of_pieces"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "out_of_sale_on"
  end

  add_index "drug_articles", ["code"], :name => "index_drug_articles_on_code"
  add_index "drug_articles", ["drug_product_id"], :name => "index_drug_articles_on_drug_product_id"
  add_index "drug_articles", ["vat_class_id"], :name => "index_drug_articles_on_vat_class_id"

  create_table "drug_prices", :force => true do |t|
    t.date     "valid_from"
    t.decimal  "price",           :precision => 8, :scale => 2
    t.string   "price_type"
    t.integer  "drug_article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "drug_prices", ["drug_article_id"], :name => "index_drug_prices_on_drug_article_id"
  add_index "drug_prices", ["price_type"], :name => "index_drug_prices_on_price_type"
  add_index "drug_prices", ["valid_from"], :name => "index_drug_prices_on_valid_from"

  create_table "drug_products", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.string   "second_name"
    t.string   "size"
    t.string   "info"
    t.boolean  "original"
    t.string   "generic_group"
    t.integer  "drug_code1_id"
    t.integer  "drug_code2_id"
    t.integer  "therap_code1_id"
    t.integer  "therap_code2_id"
    t.integer  "drug_compendium_id"
    t.string   "application_code"
    t.float    "dose_amount"
    t.string   "dose_units"
    t.string   "dose_application"
    t.integer  "interaction_relevance"
    t.boolean  "active"
    t.integer  "partner_id"
    t.integer  "drug_monograph_id"
    t.boolean  "galenic"
    t.integer  "galenic_code_id"
    t.float    "concentration"
    t.string   "concentration_unit"
    t.string   "special_drug_group_code"
    t.string   "drug_for"
    t.boolean  "probe_suited"
    t.float    "life_span"
    t.float    "application_time"
    t.string   "excip_text"
    t.string   "excip_quantity"
    t.string   "excip_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drug_substances", :id => false, :force => true do |t|
    t.string   "id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.date    "born_on"
    t.float   "workload"
    t.boolean "active",   :default => true
  end

  create_table "esr_files", :force => true do |t|
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remarks",    :default => ""
  end

  create_table "esr_records", :force => true do |t|
    t.string   "bank_pc_id"
    t.string   "reference"
    t.decimal  "amount",            :precision => 8, :scale => 2
    t.string   "payment_reference"
    t.date     "payment_date"
    t.date     "transaction_date"
    t.date     "value_date"
    t.string   "microfilm_nr"
    t.string   "reject_code"
    t.string   "reserved"
    t.string   "payment_tax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "esr_file_id"
    t.integer  "booking_id"
    t.integer  "invoice_id"
    t.string   "remarks",                                         :default => ""
    t.string   "state",                                                           :null => false
  end

  add_index "esr_records", ["booking_id"], :name => "index_esr_records_on_booking_id"
  add_index "esr_records", ["esr_file_id"], :name => "index_esr_records_on_esr_file_id"
  add_index "esr_records", ["invoice_id"], :name => "index_esr_records_on_invoice_id"

  create_table "honorific_prefixes", :force => true do |t|
    t.integer "sex"
    t.string  "name"
    t.integer "position"
  end

  create_table "imports", :force => true do |t|
    t.string   "type"
    t.integer  "update_count"
    t.integer  "create_count"
    t.integer  "delete_count"
    t.integer  "error_count"
    t.string   "error_ids"
    t.string   "error_messages"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "version"
  end

  create_table "insurance_policies", :force => true do |t|
    t.integer  "insurance_id"
    t.integer  "patient_id"
    t.date     "valid_from"
    t.date     "valid_to"
    t.string   "number"
    t.string   "policy_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "insurance_policies", ["insurance_id"], :name => "index_insurance_policies_on_insurance_id"
  add_index "insurance_policies", ["patient_id"], :name => "index_insurance_policies_on_patient_id"
  add_index "insurance_policies", ["policy_type"], :name => "index_insurance_policies_on_policy_type"

  create_table "insurances", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ean_party",       :limit => 13
    t.string   "role"
    t.string   "group_ean_party", :limit => 13
    t.integer  "imported_id"
    t.integer  "bsv_code"
  end

  add_index "insurances", ["ean_party"], :name => "index_insurances_on_ean_party"
  add_index "insurances", ["group_ean_party"], :name => "index_insurances_on_group_ean_party"
  add_index "insurances", ["imported_id"], :name => "index_insurances_on_imported_id"
  add_index "insurances", ["role"], :name => "index_insurances_on_role"

  create_table "invoice_batch_jobs", :force => true do |t|
    t.date     "value_date"
    t.integer  "count"
    t.string   "tiers_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "failed_jobs"
    t.string   "type"
  end

  create_table "invoice_batch_jobs_invoices", :id => false, :force => true do |t|
    t.integer "invoice_batch_job_id"
    t.integer "invoice_id"
  end

  create_table "invoices", :force => true do |t|
    t.text     "remark"
    t.integer  "tiers_id"
    t.integer  "law_id"
    t.integer  "treatment_id"
    t.string   "place_type",               :default => "Praxis"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                    :default => "prepared"
    t.date     "value_date"
    t.date     "due_date"
    t.integer  "invoice_replaced_by"
    t.integer  "imported_id"
    t.integer  "imported_invoice_id"
    t.string   "imported_esr_reference"
    t.date     "reminder_due_date"
    t.date     "second_reminder_due_date"
    t.date     "third_reminder_due_date"
    t.integer  "patient_vcard_id"
    t.integer  "billing_vcard_id"
  end

  add_index "invoices", ["imported_esr_reference"], :name => "index_invoices_on_imported_esr_reference"
  add_index "invoices", ["invoice_replaced_by"], :name => "index_invoices_on_invoice_replaced_by"
  add_index "invoices", ["law_id"], :name => "index_invoices_on_law_id"
  add_index "invoices", ["state"], :name => "index_invoices_on_state"
  add_index "invoices", ["tiers_id"], :name => "index_invoices_on_tiers_id"
  add_index "invoices", ["treatment_id"], :name => "index_invoices_on_treatment_id"
  add_index "invoices", ["value_date"], :name => "index_invoices_on_value_date"

  create_table "invoices_service_records", :id => false, :force => true do |t|
    t.integer "invoice_id"
    t.integer "service_record_id"
  end

  add_index "invoices_service_records", ["invoice_id"], :name => "index_invoices_service_records_on_invoice_id"
  add_index "invoices_service_records", ["service_record_id"], :name => "index_invoices_service_records_on_service_record_id"

  create_table "invoices_sessions", :id => false, :force => true do |t|
    t.integer "invoice_id"
    t.integer "session_id"
  end

  add_index "invoices_sessions", ["invoice_id", "session_id"], :name => "index_invoices_sessions_on_invoice_id_and_session_id"
  add_index "invoices_sessions", ["invoice_id"], :name => "index_invoices_sessions_on_invoice_id"
  add_index "invoices_sessions", ["session_id"], :name => "index_invoices_sessions_on_session_id"

  create_table "laws", :force => true do |t|
    t.string   "insured_id"
    t.string   "case_id"
    t.datetime "case_date"
    t.string   "ssn"
    t.string   "nif"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medical_cases", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "doctor_id"
    t.datetime "duration_from"
    t.datetime "duration_to"
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "diagnosis_id"
    t.integer  "treatment_id"
    t.integer  "imported_id"
  end

  add_index "medical_cases", ["diagnosis_id"], :name => "index_medical_cases_on_diagnosis_id"
  add_index "medical_cases", ["doctor_id"], :name => "index_medical_cases_on_doctor_id"
  add_index "medical_cases", ["patient_id"], :name => "index_medical_cases_on_patient_id"
  add_index "medical_cases", ["treatment_id"], :name => "index_medical_cases_on_treatment_id"
  add_index "medical_cases", ["type"], :name => "index_medical_cases_on_type"

  create_table "offices", :force => true do |t|
    t.string "name"
    t.string "login"
    t.string "printers"
  end

  add_index "offices", ["login"], :name => "index_offices_on_login"

  create_table "patients", :force => true do |t|
    t.date     "birth_date"
    t.integer  "sex"
    t.integer  "only_year_of_birth"
    t.integer  "doctor_id"
    t.text     "remarks",                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "dunning_stop",        :default => false
    t.boolean  "use_billing_address", :default => false
    t.boolean  "deceased",            :default => false
    t.string   "doctor_patient_nr"
    t.boolean  "active",              :default => true,  :null => false
    t.string   "name"
    t.integer  "imported_id"
    t.string   "covercard_code"
    t.boolean  "delta",               :default => true,  :null => false
  end

  add_index "patients", ["doctor_id"], :name => "patients_doctor_id_index"
  add_index "patients", ["doctor_patient_nr"], :name => "index_patients_on_doctor_patient_nr"
  add_index "patients", ["dunning_stop"], :name => "index_patients_on_dunning_stop"
  add_index "patients", ["updated_at"], :name => "patients_updated_at_index"

  create_table "people", :force => true do |t|
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at"
    t.string   "type"
    t.date     "date_of_birth"
    t.date     "date_of_death"
    t.integer  "sex"
    t.string   "social_security_nr"
    t.string   "social_security_nr_12"
    t.integer  "civil_status_id"
    t.integer  "religion_id"
    t.boolean  "delta",                 :default => true, :null => false
    t.string   "nationality"
    t.string   "swift"
    t.string   "clearing"
  end

  add_index "people", ["civil_status_id"], :name => "index_people_on_civil_status_id"
  add_index "people", ["religion_id"], :name => "index_people_on_religion_id"
  add_index "people", ["type"], :name => "index_people_on_type"

  create_table "phone_numbers", :force => true do |t|
    t.string   "number",            :limit => 50
    t.string   "phone_number_type", :limit => 50
    t.integer  "object_id"
    t.string   "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phone_numbers", ["object_id", "object_type"], :name => "index_phone_numbers_on_object_id_and_object_type"
  add_index "phone_numbers", ["phone_number_type"], :name => "index_phone_numbers_on_phone_number_type"

  create_table "postal_codes", :force => true do |t|
    t.string   "zip_type"
    t.string   "zip"
    t.string   "zip_extension"
    t.string   "locality"
    t.string   "locality_long"
    t.string   "canton"
    t.integer  "imported_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "postal_codes", ["zip"], :name => "index_postal_codes_on_zip"
  add_index "postal_codes", ["zip_type"], :name => "index_postal_codes_on_zip_type"

  create_table "recalls", :force => true do |t|
    t.integer  "patient_id"
    t.date     "due_date"
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "appointment_id"
    t.datetime "sent_at"
    t.integer  "doctor_id"
  end

  add_index "recalls", ["appointment_id"], :name => "index_recalls_on_appointment_id"
  add_index "recalls", ["doctor_id"], :name => "index_recalls_on_doctor_id"
  add_index "recalls", ["patient_id"], :name => "index_recalls_on_patient_id"
  add_index "recalls", ["state"], :name => "index_recalls_on_state"

  create_table "returned_invoices", :force => true do |t|
    t.string   "state",      :default => "ready"
    t.integer  "invoice_id"
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doctor_id"
  end

  add_index "returned_invoices", ["doctor_id"], :name => "index_returned_invoices_on_doctor_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "service_items", :force => true do |t|
    t.integer "tariff_item_id"
    t.integer "tariff_item_group_id"
    t.decimal "quantity",                           :precision => 8, :scale => 2
    t.string  "ref_code",             :limit => 10
    t.integer "position"
  end

  add_index "service_items", ["ref_code"], :name => "index_service_items_on_ref_code"
  add_index "service_items", ["tariff_item_group_id"], :name => "index_service_items_on_tariff_item_group_id"
  add_index "service_items", ["tariff_item_id"], :name => "index_service_items_on_tariff_item_id"

  create_table "service_records", :force => true do |t|
    t.string   "treatment",                                                       :default => "ambulatory"
    t.string   "tariff_type",                                                     :default => "001"
    t.string   "tariff_version",     :limit => 10
    t.string   "contract_number",    :limit => 10
    t.string   "code",               :limit => 10,                                                             :null => false
    t.string   "ref_code",           :limit => 10
    t.integer  "session",                                                         :default => 1
    t.decimal  "quantity",                          :precision => 8, :scale => 2, :default => 1.0
    t.datetime "date",                                                                                         :null => false
    t.integer  "provider_id"
    t.integer  "responsible_id"
    t.integer  "location_id"
    t.string   "billing_role",                                                    :default => "both"
    t.string   "medical_role",                                                    :default => "self_employed"
    t.string   "body_location",                                                   :default => "none"
    t.decimal  "unit_factor_mt",                    :precision => 3, :scale => 2
    t.decimal  "scale_factor_mt",                   :precision => 3, :scale => 2, :default => 1.0
    t.decimal  "external_factor_mt",                :precision => 3, :scale => 2, :default => 1.0
    t.decimal  "amount_mt",                         :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "unit_factor_tt",                    :precision => 3, :scale => 2
    t.decimal  "scale_factor_tt",                   :precision => 3, :scale => 2, :default => 1.0
    t.decimal  "external_factor_tt",                :precision => 3, :scale => 2, :default => 1.0
    t.decimal  "amount_tt",                         :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "vat_rate",                          :precision => 5, :scale => 2, :default => 0.0
    t.decimal  "splitting_factor",                  :precision => 3, :scale => 2, :default => 1.0
    t.boolean  "validate",                                                        :default => false
    t.boolean  "obligation",                                                      :default => true
    t.string   "section_code",       :limit => 6
    t.string   "remark",             :limit => 700
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_id"
    t.decimal  "unit_mt",                           :precision => 8, :scale => 2
    t.decimal  "unit_tt",                           :precision => 8, :scale => 2
    t.integer  "vat_class_id"
    t.integer  "imported_id"
  end

  add_index "service_records", ["patient_id"], :name => "index_service_records_on_patient_id"
  add_index "service_records", ["provider_id"], :name => "index_service_records_on_provider_id"
  add_index "service_records", ["responsible_id"], :name => "index_service_records_on_responsible_id"
  add_index "service_records", ["vat_class_id"], :name => "index_service_records_on_vat_class_id"

  create_table "service_records_sessions", :id => false, :force => true do |t|
    t.integer "service_record_id"
    t.integer "session_id"
  end

  add_index "service_records_sessions", ["service_record_id"], :name => "index_service_records_sessions_on_service_record_id"
  add_index "service_records_sessions", ["session_id"], :name => "index_service_records_sessions_on_session_id"

  create_table "sessions", :force => true do |t|
    t.integer  "patient_id"
    t.datetime "duration_from"
    t.datetime "duration_to"
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",         :default => "open"
    t.integer  "treatment_id"
    t.integer  "imported_id"
  end

  add_index "sessions", ["duration_from"], :name => "index_sessions_on_duration_from"
  add_index "sessions", ["patient_id"], :name => "index_sessions_on_patient_id"
  add_index "sessions", ["state"], :name => "index_sessions_on_state"
  add_index "sessions", ["treatment_id"], :name => "index_sessions_on_treatment_id"

  create_table "settings", :force => true do |t|
    t.string   "var",                       :null => false
    t.text     "value"
    t.integer  "target_id"
    t.string   "target_type", :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], :name => "index_settings_on_target_type_and_target_id_and_var", :unique => true

  create_table "tariff_codes", :force => true do |t|
    t.string   "tariff_code"
    t.string   "record_type_v4"
    t.string   "record_type_v5"
    t.string   "description"
    t.date     "valid_from"
    t.date     "valid_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_items", :force => true do |t|
    t.decimal  "amount_mt",                  :precision => 8, :scale => 2
    t.decimal  "amount_tt",                  :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.text     "remark"
    t.boolean  "obligation",                                               :default => true
    t.string   "type"
    t.string   "tariff_type",   :limit => 3
    t.integer  "vat_class_id"
    t.integer  "imported_id"
    t.string   "imported_type"
  end

  add_index "tariff_items", ["code"], :name => "index_tariff_items_on_code"
  add_index "tariff_items", ["tariff_type"], :name => "index_tariff_items_on_tariff_type"
  add_index "tariff_items", ["type"], :name => "index_tariff_items_on_type"
  add_index "tariff_items", ["vat_class_id"], :name => "index_tariff_items_on_vat_class_id"

  create_table "tenants", :force => true do |t|
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tenants", ["person_id"], :name => "index_tenants_on_person_id"

  create_table "tiers", :force => true do |t|
    t.integer  "biller_id"
    t.integer  "provider_id"
    t.integer  "insurance_id"
    t.integer  "patient_id"
    t.integer  "guarantor_id"
    t.integer  "referrer_id"
    t.integer  "employer_id"
    t.string   "type"
    t.string   "payment_periode"
    t.boolean  "invoice_modification"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tiers", ["biller_id"], :name => "index_tiers_on_biller_id"
  add_index "tiers", ["employer_id"], :name => "index_tiers_on_employer_id"
  add_index "tiers", ["guarantor_id"], :name => "index_tiers_on_guarantor_id"
  add_index "tiers", ["insurance_id"], :name => "index_tiers_on_insurance_id"
  add_index "tiers", ["patient_id"], :name => "index_tiers_on_patient_id"
  add_index "tiers", ["provider_id"], :name => "index_tiers_on_provider_id"
  add_index "tiers", ["referrer_id"], :name => "index_tiers_on_referrer_id"

  create_table "treatments", :force => true do |t|
    t.date     "date_begin"
    t.date     "date_end"
    t.string   "canton"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_id"
    t.integer  "law_id"
    t.integer  "referrer_id"
    t.string   "place_type",  :default => "Praxis"
    t.integer  "imported_id"
    t.string   "state",       :default => "open"
  end

  add_index "treatments", ["law_id"], :name => "index_treatments_on_law_id"
  add_index "treatments", ["patient_id"], :name => "index_treatments_on_patient_id"
  add_index "treatments", ["referrer_id"], :name => "index_treatments_on_referrer_id"
  add_index "treatments", ["state"], :name => "index_treatments_on_state"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "encrypted_password",        :limit => 128, :default => "",        :null => false
    t.string   "password_salt",                            :default => "",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
    t.integer  "object_id"
    t.string   "object_type"
    t.integer  "tenant_id"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.datetime "locked_at"
    t.string   "unlock_token"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count",                            :default => 0
    t.integer  "failed_attempts",                          :default => 0
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["state"], :name => "index_users_on_state"

  create_table "vat_classes", :force => true do |t|
    t.date     "valid_from"
    t.decimal  "rate",       :precision => 5, :scale => 2
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vat_classes", ["code"], :name => "index_vat_classes_on_code"
  add_index "vat_classes", ["valid_from"], :name => "index_vat_classes_on_valid_from"

  create_table "vcards", :force => true do |t|
    t.string   "full_name",        :limit => 50
    t.string   "nickname",         :limit => 50
    t.string   "family_name",      :limit => 50
    t.string   "given_name",       :limit => 50
    t.string   "additional_name",  :limit => 50
    t.string   "honorific_prefix", :limit => 50
    t.string   "honorific_suffix", :limit => 50
    t.boolean  "active",                         :default => true
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "vcard_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vcards", ["object_id", "object_type"], :name => "index_vcards_on_object_id_and_object_type"

end
