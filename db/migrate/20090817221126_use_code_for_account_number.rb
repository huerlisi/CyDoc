class UseCodeForAccountNumber < ActiveRecord::Migration
  def self.up
    add_column :accounts, :code, :string
    
    Accounting::Account.all.each {|account|
      if account.is_a? Accounting::BankAccount
        account.code = '1000'
      else
        account.code = account.number
      end
    }
  end

  def self.down
    remove_column :accounts, :code
  end
end
