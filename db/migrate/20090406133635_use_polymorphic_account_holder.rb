class UsePolymorphicAccountHolder < ActiveRecord::Migration
  def self.up
    add_column :accounts, :holder_id, :integer
    add_column :accounts, :holder_type, :string
    
    BankAccount.all.each do |bank_account|
      next if bank_account.holder_vcard_id.nil?
      
      vcard = Vcards::Vcard.find(bank_account.holder_vcard_id)
      bank_account.holder = vcard.object
      bank_account.save
    end

    remove_column :accounts, :holder_vcard_id
  end

  def self.down
  end
end
