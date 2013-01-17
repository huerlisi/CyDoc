# -*- encoding : utf-8 -*-
class SetVcardTypes < ActiveRecord::Migration
  def self.up
    Vcard.update_all "vcard_type = 'private'", "vcard_type IS NULL AND object_type = 'Patient'"
  end

  def self.down
  end
end
