# -*- encoding : utf-8 -*-
class RemoveVcardIdFromInsurance < ActiveRecord::Migration
  def self.up
    remove_column :insurances, :vcard_id
  end

  def self.down
  end
end
