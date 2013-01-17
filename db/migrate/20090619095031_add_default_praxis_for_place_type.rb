# -*- encoding : utf-8 -*-
class AddDefaultPraxisForPlaceType < ActiveRecord::Migration
  def self.up
    change_column :invoices, :place_type, :string, :default => 'Praxis'
    Invoice.update_all "place_type = 'Praxis'", "place_type IS NULL"
    
    change_column :treatments, :place_type, :string, :default => 'Praxis'
    Treatment.update_all "place_type = 'Praxis'", "place_type IS NULL"
  end

  def self.down
  end
end
