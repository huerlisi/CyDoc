require 'tiers'
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
        :remark                 => import_record.txBemerkung,
        :law                    => self.treatment.law,
        :place_type             => 'praxis',
        # :state => import_record.shStatus,
        :value_date             => import_record.dtRechnung,
        :due_date               => (import_record.dtRechnung.nil? ? nil : import_record.dtRechnung + import_record.inZahlungsfrist),
        :imported_invoice_id    => import_record.inBelegNummer,
        :imported_esr_reference => import_record.txESRReferenzNummer
      }

      self.tiers = TiersGarant.new(
        :patient  => ::Patient.find_or_import(import_record.fall.stamm),
        :biller   => ::Doctor.first,
        :provider => ::Doctor.first        
      )
      
      self.state = import_record.status if state == 'prepared'
      unless import_record.txStornoGrund.blank?
        self.state = 'canceled'
        self.remark ||= ''
        self.remark += "Storniert: #{import_record.txStornoGrund}"
      end

      for debitor in import_record.debitoren
        booking = Accounting::Booking.find_by_imported_id_and_title(debitor.id, 'Rechnung')
        booking ||= Accounting::Booking.new(
          :amount => debitor.snBetrag,
          :title  => 'Rechnung',
          :credit_account => ::Invoice::EARNINGS_ACCOUNT,
          :debit_account  => ::Invoice::DEBIT_ACCOUNT,
          :value_date => debitor['dtFälligkeit'],
          :imported_id => debitor.id
        )
        self.bookings << booking
        booking.save
        self.state = 'booked' if state == 'prepared'

        for mahnung in debitor.mahnungen
          reminder_booking = Accounting::Booking.new(
            :title          => "#{mahnung.stufe} (Gebühr #{sprintf('%0.2f', mahnung.snSpesen.currency_round)})",
            :amount         => mahnung.snSpesen.currency_round,
            :reference      => booking.reference,
            :value_date     => mahnung.dtMahndatum,
            :credit_account => booking.credit_account,
            :debit_account  => booking.debit_account
          )
          reminder_booking.save
        end

        aktive_mahnung = debitor.mahnungen.find(:first, :conditions => ['tfInaktiv = ?', false])
        self.state = aktive_mahnung.status if aktive_mahnung
      end

      for zahlung in import_record.zahlungen
        booking = Accounting::Booking.find_by_imported_id_and_title(zahlung.id, 'Zahlung')
        booking ||= Accounting::Booking.new(
          :amount => zahlung.snBetrag,
          :title  => 'Zahlung',
          :credit_account => ::Accounting::Account.find_by_code('1100'),
          :debit_account  => ::Accounting::Account.find_by_code('1020'),
          :value_date => zahlung.dtValutadatum,
          :imported_id => zahlung.id
        )
        self.bookings << booking
        booking.save
      end

      self.booking_saved(nil)

      self.save(false)
      return self
    end
  end
end

Invoice.send :include, Praxidata::Import, Praxidata::Invoice
