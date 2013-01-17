# -*- encoding : utf-8 -*-
class MakeMedicalCaseSuperclass < ActiveRecord::Migration
  def self.up
    add_column :medical_cases, :type, :string
  end

  def self.down
    remove_column :medical_cases, :type
  end
end
