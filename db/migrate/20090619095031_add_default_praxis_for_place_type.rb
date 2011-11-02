class AddDefaultPraxisForPlaceType < ActiveRecord::Migration
  def self.up
    change_column :invoices, :place_type, :string, :default => 'Praxis'
    change_column :treatments, :place_type, :string, :default => 'Praxis'
  end

  def self.down
  end
end
