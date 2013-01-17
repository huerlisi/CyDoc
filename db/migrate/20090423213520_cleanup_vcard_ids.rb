# -*- encoding : utf-8 -*-
class CleanupVcardIds < ActiveRecord::Migration
  def self.up
    drop_table :patient_vcards
    
    remove_column :patients, :billing_vcard_id

    remove_column :vcards, :address
    remove_column :vcards, :address_id
    remove_column :vcards, :billing_address_id
  end

  def self.down
  end
end
