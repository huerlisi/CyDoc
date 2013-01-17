# -*- encoding : utf-8 -*-
class CleanupMoreCytoTables < ActiveRecord::Migration
  def self.up
    drop_table :finding_groups
    drop_table :mailings
    drop_table :order_forms
   
    remove_column :medical_cases, :zytolabor_case_id
  end

  def self.down
  end
end
