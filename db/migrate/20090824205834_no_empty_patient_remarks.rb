# -*- encoding : utf-8 -*-
class NoEmptyPatientRemarks < ActiveRecord::Migration
  def self.up
    change_column :patients, :remarks, :text, :default => '', :null => false
  end

  def self.down
  end
end
