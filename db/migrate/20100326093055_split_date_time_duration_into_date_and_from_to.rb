# -*- encoding : utf-8 -*-
class SplitDateTimeDurationIntoDateAndFromTo < ActiveRecord::Migration
  def self.up
    add_column :appointments, :date, :date
    add_column :appointments, :from, :time
    add_column :appointments, :to, :time
    
    remove_column :appointments, :duration_from
    remove_column :appointments, :duration_to
  end

  def self.down
    add_column :appointments, :duration_from, :datetime
    add_column :appointments, :duration_to, :datetime

    remove_column :appointments, :date
    remove_column :appointments, :from
    remove_column :appointments, :to
  end
end
