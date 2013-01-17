# -*- encoding : utf-8 -*-
class RenameDiagnoseIdToDiagnosisId < ActiveRecord::Migration
  def self.up
    rename_column :diagnoses_treatments, :diagnose_id, :diagnosis_id
  end

  def self.down
  end
end
