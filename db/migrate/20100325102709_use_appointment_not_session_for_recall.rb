# -*- encoding : utf-8 -*-
class UseAppointmentNotSessionForRecall < ActiveRecord::Migration
  def self.up
    # Create appointments table
    create_table :appointments do |t|
      t.references :patient
      t.references :recall
      t.references :treatment
      t.datetime :duration_from
      t.datetime :duration_to
      t.text :remarks
      t.string :state
      
      t.timestamps
    end
    
    add_index :appointments, :patient_id
    add_index :appointments, :recall_id
    add_index :appointments, :treatment_id
    add_index :appointments, :state
    
    # Add appointment association
    remove_column :recalls, :session_id
    add_column :recalls, :appointment_id, :integer

    add_index :recalls, :appointment_id
  end

  def self.down
    remove_index :recalls, :appointment_id
    remove_column :recalls, :appointment_id, :integer
    add_column :recalls, :session_id
    
    drop_table :appointments
  end
end
