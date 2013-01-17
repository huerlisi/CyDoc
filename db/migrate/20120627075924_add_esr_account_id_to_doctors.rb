# -*- encoding : utf-8 -*-
class AddEsrAccountIdToDoctors < ActiveRecord::Migration
  def self.up
    add_column :doctors, :esr_account_id, :integer

    Doctor.find_each do |doctor|
      esr_account = doctor.accounts.find(:first, :conditions => {:type => 'BankAccount'})
      if esr_account
        doctor.esr_account_id = esr_account.id
        doctor.save
      end
    end
  end

  def self.down
    remove_column :doctors, :esr_account_id
  end
end
