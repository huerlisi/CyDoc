require 'accounting/booking'

module Praxidata
  module Booking
    def import(import_record)
      self.save
      return self
    end
  end
end

Accounting::Booking.send :include, Praxidata::Import, Praxidata::Booking
