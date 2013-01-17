# -*- encoding : utf-8 -*-
class RemoveBillingDoctorFromDoctors < ActiveRecord::Migration
  def self.up
    remove_column :doctors, :billing_doctor_id
  end

  def self.down
    add_column :doctors, :billing_doctor_id, :integer
  end
end
