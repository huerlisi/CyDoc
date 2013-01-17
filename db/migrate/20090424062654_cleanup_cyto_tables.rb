# -*- encoding : utf-8 -*-
class CleanupCytoTables < ActiveRecord::Migration
  def self.up
    drop_table :cases
    drop_table :cases_finding_classes
    drop_table :cases_mailings
    drop_table :classification_groups
    drop_table :classifications
    drop_table :examination_methods
    drop_table :finding_classes
    drop_table :finding_classes_finding_groups
    drop_table :top_finding_classes
  end

  def self.down
  end
end
