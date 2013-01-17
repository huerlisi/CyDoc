# -*- encoding : utf-8 -*-
class CreateEsrFiles < ActiveRecord::Migration
  def self.up
    create_table :esr_files do |t|
      t.integer :size
      t.string :content_type
      t.string :filename

      t.timestamps
    end
  end

  def self.down
    drop_table :esr_files
  end
end
