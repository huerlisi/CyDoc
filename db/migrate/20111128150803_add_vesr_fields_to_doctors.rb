# -*- encoding : utf-8 -*-
class AddVesrFieldsToDoctors < ActiveRecord::Migration
  def self.up
    add_column :doctors, :use_vesr, :boolean
    add_column :doctors, :print_payment_for, :boolean
  end

  def self.down
    remove_column :doctors, :print_payment_for
    remove_column :doctors, :use_vesr
  end
end
