# -*- encoding : utf-8 -*-
class SwitchBookingTitleAndCommentsForManualBookings < ActiveRecord::Migration
  def self.up
    for booking in Accounting::Booking.find :all, :conditions => {:comments => ['Barzahlung', 'Bankzahlung', 'Skonto/Rabatt', 'Zusatzleistung']}
      title = booking.comments
      booking.comments = booking.title
      booking.title = title
      booking.save
    end
  end

  def self.down
  end
end
