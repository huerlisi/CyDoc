class AddPatientIdToTreatments < ActiveRecord::Migration
  def self.up
    add_column :treatments, :patient_id, :integer
    
    Treatment.all.map {|t|
      t.patient = t.invoice.patient
      t.save
    }
  end

  def self.down
    remove_column :treatments, :patient_id
  end
end
