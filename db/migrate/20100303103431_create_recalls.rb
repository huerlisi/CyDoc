# -*- encoding : utf-8 -*-
class CreateRecalls < ActiveRecord::Migration
  def self.up
    create_table :recalls do |t|
      t.references :patient
      t.date :due_date
      t.text :remarks
      
      t.timestamps
    end
    
    add_index :recalls, :patient_id
  end

  def self.down
    drop_table :recalls
  end
end
