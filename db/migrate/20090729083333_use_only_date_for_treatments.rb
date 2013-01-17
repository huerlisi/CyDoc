# -*- encoding : utf-8 -*-
class UseOnlyDateForTreatments < ActiveRecord::Migration
  def self.up
    change_column :treatments, :date_begin, :date
    change_column :treatments, :date_end, :date
  end

  def self.down
    change_column :treatments, :date_begin, :datetime
    change_column :treatments, :date_end, :datetime
  end
end
