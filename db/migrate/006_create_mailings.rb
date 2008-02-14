class CreateMailings < ActiveRecord::Migration
  def self.up
    create_table :mailings do |t|
      t.integer :doctor_id
      t.datetime :printed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :mailings
  end
end
