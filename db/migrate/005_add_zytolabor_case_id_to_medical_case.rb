# -*- encoding : utf-8 -*-
class AddZytolaborCaseIdToMedicalCase < ActiveRecord::Migration
  def self.up
    add_column :medical_cases, :zytolabor_case_id, :integer
  end

  def self.down
    remove_column :medical_cases, :zytolabor_case_id
  end
end
