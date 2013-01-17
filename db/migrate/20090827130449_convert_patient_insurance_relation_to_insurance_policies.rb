# -*- encoding : utf-8 -*-
require 'patient.rb'
class Patient
  belongs_to :insurance
end

class ConvertPatientInsuranceRelationToInsurancePolicies < ActiveRecord::Migration

  def self.up
    for patient in Patient.all
      if patient.insurance
        patient.insurance_policies.create(
          :insurance   => patient.insurance,
          :number      => patient.insurance_nr,
          :policy_type => 'KVG'
        )
      end
    end
    
    remove_columns :patients, :insurance_id, :insurance_nr
  end

  def self.down
    add_column :patients, :insurance_id, :integer
    add_column :patients, :insurance_nr, :string
  
    for patient in Patient.all
      insurance_policy = patient.insurance_policies.first
      
      next if insurance_policy.nil?
      
      patient.insurance_id = insurance_policy.insurance_id
      patient.insurance_nr = insurance_policy.number
      
      patient.save
    end
  end
end
