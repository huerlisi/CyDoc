class DropTableOffices < ActiveRecord::Migration
  def up
    drop_table :offices
    drop_table :doctors_offices
  end
end
