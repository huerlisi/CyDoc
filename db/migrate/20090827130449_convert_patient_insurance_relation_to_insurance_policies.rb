require 'patient.rb'
class Patient
  belongs_to :insurance
end

class ConvertPatientInsuranceRelationToInsurancePolicies < ActiveRecord::Migration

  def self.up
    for patient in Patient.all
      patient.insurance_policies.create(
        :insurance   => patient.insurance,
        :number      => patient.insurance_nr,
        :policy_type => 'Krankenversicherung'
      )
    end
    
    remove_columns :patients, :insurance_id, :insurance_nr
  end

  def self.down
  end
end
