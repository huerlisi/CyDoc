# -*- encoding : utf-8 -*-
require 'fastercsv'

module Google
  class ContactsImporter
    def self.import(r)
      p = Patient.new
      p.birth_date = Date.today

      p.given_name = r['First Name']
      p.family_name = r['Last Name']
      p.remarks = r['Notes'] || ''

      p.phone_numbers << PhoneNumber.new(:number => r['Home Phone'], :phone_number_type => 'Festnetz (Privat)') if r['Home Phone'].present?
      p.phone_numbers << PhoneNumber.new(:number => r['Business Phone'], :phone_number_type => 'Festnetz (gesch.)') if r['Business Phone'].present?
      p.phone_numbers << PhoneNumber.new(:number => r['Mobile Phone'], :phone_number_type => 'Mobile') if r['Mobile Phone'].present?
      p.phone_numbers << PhoneNumber.new(:number => r['E-mail Address'], :phone_number_type => 'E-Mail') if r['E-mail Address'].present?

      address = r['Business Address']
      unless address.blank?
        a = p.vcard.build_address
        a.street_address = address.split("\n")[0]
        a.postal_code = address.split("\n")[1].split(' ')[-1]
        a.locality = address.split("\n")[1].split(' ')[0..-2].to_s
      end
      address = r['Home Address']
      unless address.blank?
        a = p.vcard.build_address
        a.street_address = address.split("\n")[0]
        a.postal_code = address.split("\n")[1].split(' ')[-1]
        a.locality = address.split("\n")[1].split(' ')[0..-2].to_s
      end
      p.save
    end

    def self.import_all
      records = FasterCSV.parse(File.new(File.join(Rails.root, 'data', 'google', 'contacts.csv')), {:headers => true})

      for record in records
        import(record)
      end
    end
  end
end
