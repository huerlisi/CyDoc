# -*- encoding : utf-8 -*-
class AddRemarksToEsrFiles < ActiveRecord::Migration
  def self.up
    add_column :esr_files, :remarks, :string
  end

  def self.down
    remove_column :esr_files, :remarks
  end
end
