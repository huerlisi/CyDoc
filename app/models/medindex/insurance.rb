module Medindex
  class Insurance < Base
    def self.import_record(ext_record)
      raise SkipException if ext_record.field('EAN').empty?

      int_record = int_class.new
      
      int_record.ean_party = ext_record.field('EAN')
      int_record.group_ean_party = ext_record.field('GROUP_EAN')
      int_record.role = ext_record.field('ROLE')

      # TODO: import REFNO
      # TODO: import LANG

      int_record.vcard = Vcards::Vcard.new(
              :full_name => ext_record.field('DESCR1'),
              :street_address => [ext_record.field('ADDR/STREET'), ext_record.field('ADDR/STRNO')].compact.join(" "),
              :extended_address => ext_record.field('ADDR/POBOX'),
              :postal_code => ext_record.field('ADDR/ZIP'),
              :locality => ext_record.field('ADDR/CITY')
      )
      
      return int_record
    end
  end
end
