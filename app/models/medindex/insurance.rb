module Medindex
  class Insurance < Listener
    def int_class
      Kernel::Insurance
    end
    
    def record_name
      'INS'
    end
    
    def tag_start(name, attrs)
      super
      
      case name
        when 'ADDR': @vcard = @int_record.vcards.build
      end
    end
    
    def tag_end(name)
      case name
        when record_name:
          @int_record.save!
          puts @int_record

        when 'EAN': @int_record.ean_party = @text
        when 'GROUP_EAN': @int_record.group_ean_party = @text
        when 'ROLE': @int_record.role = @text
        when 'DESCR1': @int_record.full_name = @text
        when 'ZIP': @int_record.postal_code = @text
        when 'CITY': @int_record.locality = @text
        when 'POBOX': @int_record.extended_address = @text
      end
    end
  end
end
