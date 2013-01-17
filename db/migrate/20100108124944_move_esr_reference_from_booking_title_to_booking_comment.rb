# -*- encoding : utf-8 -*-
class MoveEsrReferenceFromBookingTitleToBookingComment < ActiveRecord::Migration
  def self.up
    vesr_bookings = Accounting::Booking.find(:all, :conditions => "title LIKE 'VESR Zahlung %'")
    new_bookings = vesr_bookings.map{|booking|
      title = booking.title
      booking.title = "VESR Zahlung"
      ref = title.gsub("VESR Zahlung ", '')
      com = booking.comments.gsub(/Rechnung #[0-9, ]*/, '')
      booking.comments = "Referenz #{ref} #{com}"
      
      booking.save
      
      booking
    }
    
    puts new_bookings
  end

  def self.down
  end
end
