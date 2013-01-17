# -*- encoding : utf-8 -*-
class RemoveVcardIdsFromEmployee < ActiveRecord::Migration
  def self.up
    remove_column :employees, :work_vcard_id
    remove_column :employees, :private_vcard_id
    remove_column :employees, :code
  end

  def self.down
    add_column :employees, :work_vcard_id, :integer
    add_column :employees, :private_vcard_id, :integer
    add_column :employees, :code, :string
  end
end
