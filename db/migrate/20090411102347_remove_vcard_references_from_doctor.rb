# -*- encoding : utf-8 -*-
class RemoveVcardReferencesFromDoctor < ActiveRecord::Migration
  def self.up
    remove_column :doctors, :praxis_vcard
    remove_column :doctors, :private_vcard
  end

  def self.down
  end
end
