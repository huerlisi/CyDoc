# -*- encoding : utf-8 -*-
class SetEsrAccountForDoctor < ActiveRecord::Migration
  def self.up
    User.find_each do |user|
      # Guard
      next unless user.object.is_a?(Doctor)

      doctor = user.object
      account = doctor.accounts.find(:first, :conditions => {:type => "BankAccount"})
      doctor.esr_account = account
      doctor.save!
    end
  end
end
