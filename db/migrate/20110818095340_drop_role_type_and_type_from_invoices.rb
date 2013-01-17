# -*- encoding : utf-8 -*-
class DropRoleTypeAndTypeFromInvoices < ActiveRecord::Migration
  def self.up
    remove_column :invoices, :role_type
    remove_column :invoices, :role_title
  end

  def self.down
  end
end
