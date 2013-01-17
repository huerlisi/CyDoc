# -*- encoding : utf-8 -*-
class AddIndexToVatClasses < ActiveRecord::Migration
  def self.up
    add_index :vat_classes, :code
    add_index :vat_classes, :valid_from
  end

  def self.down
    remove_index :vat_classes, :code
    remove_index :vat_classes, :valid_from
  end
end
