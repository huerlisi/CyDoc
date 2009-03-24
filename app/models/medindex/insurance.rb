module Medindex
  class Insurance < Base
    def self.import
      for ext_record in self.all
        int_record = Kernel::Insurance.new
        
        int_record.ean_party = ext_record.field('EAN')
        int_record.vcard = Vcards::Vcard.new(
        	:full_name => ext_record.field('DESCR1'),
        	:street_address => [ext_record.field('ADDR/STREET'), ext_record.field('ADDR/STRNO')].compact.join(" "),
              	:extended_address => ext_record.field('ADDR/POBOX'),
              	:postal_code => ext_record.field('ADDR/ZIP'),
        	:locality => ext_record.field('ADDR/CITY')
        )

        puts int_record.ean_party
        
        int_record.save!
      end
    end
  end
end
