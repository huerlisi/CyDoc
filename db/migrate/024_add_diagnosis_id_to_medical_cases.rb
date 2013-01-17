# -*- encoding : utf-8 -*-
class AddDiagnosisIdToMedicalCases < ActiveRecord::Migration
  def self.up
    add_column :medical_cases, :diagnosis_id, :integer
  end

  def self.down
  end
end
