# -*- encoding : utf-8 -*-
class AddPatientIdToRecordTarmeds < ActiveRecord::Migration
  def self.up
    add_column :record_tarmeds, :patient_id, :integer
  end

  def self.down
    remove_column :record_tarmeds, :patient_id
  end
end
