# -*- encoding : utf-8 -*-
class EmptyStringAsDefaultRemarksForEsrTables < ActiveRecord::Migration
  def self.up
    change_column_default :esr_files, :remarks, ''
    change_column_default :esr_records, :remarks, ''
  end

  def self.down
  end
end
