# -*- encoding : utf-8 -*-
class CreateDiagnosesSessions < ActiveRecord::Migration
  def self.up
    create_table :diagnoses_sessions, :id => false do |t|
      t.integer :diagnosis_id
      t.integer :session_id
    end
  end

  def self.down
    drop_table :diagnoses_sessions
  end
end
