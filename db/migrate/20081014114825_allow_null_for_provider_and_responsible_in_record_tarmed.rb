# -*- encoding : utf-8 -*-
class AllowNullForProviderAndResponsibleInRecordTarmed < ActiveRecord::Migration
  def self.up
    change_column :record_tarmeds, :provider_id, :integer, :null => true
    change_column :record_tarmeds, :responsible_id, :integer, :null => true
  end

  def self.down
    change_column :record_tarmeds, :provider_id, :integer, :null => false
    change_column :record_tarmeds, :responsible_id, :integer, :null => false
  end
end
