# -*- encoding : utf-8 -*-
class CreateHabtmTableDiagnosesTreatments < ActiveRecord::Migration
  def self.up
    create_table "diagnoses_treatments", :id => false do |t|
      t.integer "diagnose_id"
      t.integer "treatment_id"
    end
  end

  def self.down
  end
end
