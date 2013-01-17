# -*- encoding : utf-8 -*-
class MakePhoneNumbersPolymorphic < ActiveRecord::Migration
  def self.up
    add_column :phone_numbers, :object_id, :integer
    add_column :phone_numbers, :object_type, :string
    
    Vcards::PhoneNumber.update_all "object_id = vcard_id, object_type = 'Vcards::Vcard'"
    
    remove_column :phone_numbers, :vcard_id
  end

  def self.down
  end
end
