# -*- encoding : utf-8 -*-
class AddStaticInvoiceFieldsToTreatments < ActiveRecord::Migration
  def self.up
    add_column :treatments, :law_id, :integer
    add_column :treatments, :referrer_id, :integer
    add_column :treatments, :place_type, :string
    
    Treatment.all.map{|t|
      begin
        i = t.invoices.first

        t.law        = i.law
        t.referrer   = i.referrer
        t.place_type = i.place_type

        t.save
      rescue
      end
    }
  end

  def self.down
    remove_column :treatments, :place_type
    remove_column :treatments, :referrer_id
    remove_column :treatments, :law_id
  end
end
