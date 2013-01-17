# -*- encoding : utf-8 -*-
class AddDefaultsToRecordTarmeds < ActiveRecord::Migration
  def self.up
    rename_column :record_tarmeds, :unit_tm, :unit_mt

    change_column :record_tarmeds, :treatment, :string, :default => 'ambulatory'
    change_column :record_tarmeds, :tariff_type, :string, :default => '001'
    change_column :record_tarmeds, :tariff_version, :string, :limit => 10
    change_column :record_tarmeds, :contract_number, :string, :limit => 10
    change_column :record_tarmeds, :code, :string, :limit => 10, :null => false
    change_column :record_tarmeds, :ref_code, :string, :limit => 10
    change_column :record_tarmeds, :session, :integer, :default => 1
    change_column :record_tarmeds, :quantity, :float, :null => false
    change_column :record_tarmeds, :date, :datetime, :null => false
    change_column :record_tarmeds, :provider_id, :integer, :null => false
    change_column :record_tarmeds, :responsible_id, :integer, :null => false
    change_column :record_tarmeds, :billing_role, :string, :default => 'both'
    change_column :record_tarmeds, :medical_role, :string, :default => 'self_employed'
    change_column :record_tarmeds, :body_location, :string, :default => 'none'
    change_column :record_tarmeds, :unit_mt, :float, :null => false
    change_column :record_tarmeds, :unit_factor_mt, :float, :null => false
    change_column :record_tarmeds, :scale_factor_mt, :float, :default => 1.0
    change_column :record_tarmeds, :external_factor_mt, :float, :default => 1.0
    change_column :record_tarmeds, :amount_mt, :float, :default => 0.0
    change_column :record_tarmeds, :unit_tt, :float, :null => false
    change_column :record_tarmeds, :unit_factor_tt, :float, :null => false
    change_column :record_tarmeds, :scale_factor_tt, :float, :default => 1.0
    change_column :record_tarmeds, :external_factor_tt, :float, :default => 1.0
    change_column :record_tarmeds, :amount_tt, :float, :default => 0.0
    change_column :record_tarmeds, :amount, :float, :null => false
    change_column :record_tarmeds, :vat_rate, :float, :default => 0.0
    change_column :record_tarmeds, :splitting_factor, :float, :default => 1.0
    change_column :record_tarmeds, :validate, :boolean, :default => false
    change_column :record_tarmeds, :obligation, :boolean, :default => true
    change_column :record_tarmeds, :section_code, :string, :limit => 6
    change_column :record_tarmeds, :remark, :string, :limit => 700
  end

  def self.down
  end
end
