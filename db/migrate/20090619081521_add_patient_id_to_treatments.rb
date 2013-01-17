# -*- encoding : utf-8 -*-
class AddPatientIdToTreatments < ActiveRecord::Migration
  def self.up
    add_column :treatments, :patient_id, :integer
    
    Treatment.all.map {|t|
      begin
        i = t.invoices.first
        t.patient = i.patient
        t.save
      rescue
      end
    }
  end

  def self.down
    remove_column :treatments, :patient_id
  end
end
