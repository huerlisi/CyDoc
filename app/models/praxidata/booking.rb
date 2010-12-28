require 'accounting/booking'

module Praxidata
  module Booking
    def import(import_record)
      self.save
      return self
    end
  end
end

::Booking.send :include, Praxidata::Import, Praxidata::Booking
