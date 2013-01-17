# -*- encoding : utf-8 -*-
class RenameConsultationToSession < ActiveRecord::Migration
  def self.up
    rename_table :consultations, :sessions
    
    remove_column :sessions, :doctor_id
    add_column :sessions, :state, :string, :default => 'open'
  end

  def self.down
  end
end
