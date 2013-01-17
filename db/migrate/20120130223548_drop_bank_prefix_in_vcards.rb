# -*- encoding : utf-8 -*-
class DropBankPrefixInVcards < ActiveRecord::Migration
  def self.up
    Vcard.update_all("object_type = 'Bank'", "object_type = 'Accounting::Bank'")
  end
end
