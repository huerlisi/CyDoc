require 'invoice'

module Praxidata
  module Invoice
    def import(import_record)
      self.treatment = ::Treatment.find_or_import(import_record.fall)
      
      for sitzung in import_record.sitzungen
        self.treatment.sessions << ::Session.find_or_import(sitzung)
      end
      self.treatment.save
      
      self.service_records = self.treatment.sessions.collect{|s| s.service_records}.flatten

      self.attributes = {
        :remark => import_record.txBemerkung,
        :law    => self.treatment.law,
        :place_type => 'praxis',
        # :state => import_record.shStatus,
        :value_date => import_record.dtRechnung,
        :due_date => (import_record.dtRechnung.nil? ? nil : import_record.dtRechnung + import_record.inZahlungsfrist)
      }
      
      self.tiers = Tiers.new(
        :patient  => ::Patient.find_or_import(import_record.fall.stamm),
        :biller   => ::Doctor.first,
        :provider => ::Doctor.first        
      )
      
      unless import_record.txStornoGrund.blank?
        self.state = 'cancelled'
        self.remark ||= ''
        self.remark += "Storniert: #{import_record.txStornoGrund}"
      end

      for debitor in import_record.debitoren
        booking = Accounting::Booking.new(
          :amount => debitor.snBetrag,
          :title  => 'Rechnung',
          :credit_account => ::Invoice::EARNINGS_ACCOUNT,
          :debit_account  => ::Invoice::DEBIT_ACCOUNT,
          :value_date => debitor['dtFälligkeit']
        )
        self.bookings << booking
        booking.save
        self.state = 'booked'
      end

      for zahlung in import_record.zahlungen
        booking = Accounting::Booking.new(
          :amount => zahlung.snBetrag,
          :title  => 'Zahlung',
          :credit_account => ::Accounting::Account.find_by_code('1100'),
          :debit_account  => ::Accounting::Account.find_by_code('1020'),
          :value_date => zahlung.dtValutadatum
        )
        self.bookings << booking
        booking.save
        self.booking_saved(booking)
      end

      self.save
      return self
    end
  end
end

Invoice.send :include, Praxidata::Import, Praxidata::Invoice
