# -*- encoding : utf-8 -*-
class AddBookingIdToEsrRecords < ActiveRecord::Migration
  def self.up
    add_column :esr_records, :booking_id, :integer
  end

  def self.down
    remove_column :esr_records, :booking_id
  end
end
