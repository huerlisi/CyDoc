module Medindex
  class Insurance < Base
  end
end

# monkey patch Insurance class
class Insurance
  def self.import_medindex
    for ext_record in Medindex::Insurance.all
      int_record = self.new
      
      int_record.ean_party = ext_record.elements['EAN/text()'].to_s
      int_record.vcard = Vcards::Vcard.new(:full_name => ext_record.elements['DESCR1/text()'].to_s)

      puts int_record.ean_party
      
      int_record.save!
    end
  end
end
