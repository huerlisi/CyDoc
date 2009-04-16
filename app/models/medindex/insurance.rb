module Medindex
  class Insurance < Base
    def self.import_record(ext_record)
      raise SkipException if ext_record.field('EAN').empty?

      int_record = int_class.new
      
      int_record.id = ext_record.field('EAN')
      if ext_record.field('GROUP_EAN').empty?
        int_record.group_id = ext_record.field('EAN')
      else
        int_record.group_id = ext_record.field('GROUP_EAN')
      end
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
