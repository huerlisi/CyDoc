# -*- encoding : utf-8 -*-
class DropUnusedPatientAdressTable < ActiveRecord::Migration
  def self.up
    drop_table :patient_adresses
  end

  def self.down
  end
end
