class UseEanAsIdForInsurance < ActiveRecord::Migration
  def self.up
    change_column :patients, :insurance_id, :string, :limit => 13
    for patient in Patient.find(:all, :conditions => 'insurance_id IS NOT NULL')
      patient.insurance_id = patient.insurance.ean_party unless patient.insurance.nil?
      patient.save
    end

    change_column :tiers, :insurance_id, :string, :limit => 13
    for tiers in Tiers.find(:all, :conditions => 'insurance_id IS NOT NULL')
      tiers.insurance_id = tiers.insurance.ean_party unless tiers.insurance.nil?
      tiers.save
    end

    change_column :cases, :insurance_id, :string, :limit => 13
    for a_case in Case.find(:all, :conditions => 'insurance_id IS NOT NULL')
      a_case.insurance_id = a_case.insurance.ean_party unless a_case.insurance.nil?
      a_case.save
    end

    remove_column :insurances, :id
    rename_column :insurances, :ean_party, :id
  end

  def self.down
  end
end
