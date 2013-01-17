# -*- encoding : utf-8 -*-
class AddTreatmentIdToMedicalCases < ActiveRecord::Migration
  def self.up
    add_column :medical_cases, :treatment_id, :integer
  end

  def self.down
    remove_column :medical_cases, :treatment_id
  end
end
