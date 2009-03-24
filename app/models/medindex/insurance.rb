module Medindex
  class Insurance < Base
    def self.import
      for ext_record in self.all
        int_record = Kernel::Insurance.new
        
        int_record.ean_party = ext_record.elements['EAN/text()'].to_s
        int_record.vcard = Vcards::Vcard.new(:full_name => ext_record.elements['DESCR1/text()'].to_s)

        puts int_record.ean_party
        
        int_record.save!
      end
    end
  end
end
