class SetEsrAccountForDoctor < ActiveRecord::Migration
  def self.up
    User.find_each do |user|
      doctor = user.object
      account = doctor.accounts.find(:first, :conditions => {:type => "BankAccount"})
      doctor.esr_account = account
      doctor.save!
    end
  end
end
