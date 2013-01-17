# -*- encoding : utf-8 -*-
class FixBookingConfusion < ActiveRecord::Migration
  def self.up
    # No negative booking amounts:
    puts Accounting::Account.overview
    
    Accounting::Booking.find(:all, :conditions => "amount < 0 AND imported_id IS NULL").map {|b|
      puts b.reference.nil? ? b.to_s : b.reference.to_s
      puts "    #{b.to_s}"
      credit_account = b.credit_account
      b.credit_account = b.debit_account
      b.debit_account = credit_account
      
      b.amount = -(b.amount)
      b.save
      puts " => #{b.to_s}"
    }

    puts Accounting::Account.overview


    # All bookings are switched
    puts Accounting::Account.overview
    
    Accounting::Booking.all.map {|b|
      puts b.reference.nil? ? b.to_s : b.reference.to_s
      puts "    #{b.to_s}"
      credit_account = b.credit_account
      b.credit_account = b.debit_account
      b.debit_account = credit_account

      b.save
      puts " => #{b.to_s}"
    }

    puts Accounting::Account.overview
  end

  def self.down
  end
end
