class AddActivePerson < ActiveRecord::Migration
  def change
    add_column :people, :active, :boolean, :default => true
  end
end
