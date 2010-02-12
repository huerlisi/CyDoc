module Medindex
  class Insurance < Listener
    # Meta info
    def self.int_class
      Kernel::Insurance
    end
    
    def id_element
      'EAN'
    end
    
    def record_name
      'INS'
    end
    
    # Stream handlers
    def tag_start(name, attrs)
      super
      
#      case name
#        when record_name: @vcard = @int_record.vcards.build

#      TODO: only create vcard for additional addresses
#      case name
#        when 'ADDR': @vcard = @int_record.vcards.build
#      end
    end
    
    def tag_end(name)
      super

      case name
        when 'EAN':       @int_record.ean_party       = @text
        when 'GROUP_EAN': @int_record.group_ean_party = @text
        when 'ROLE':      @int_record.role            = @text
      # Vcard
#        when 'ADDR' :  @vcard.save!
        when 'DESCR1':    @int_record.full_name        = @text
        when 'ZIP':       @int_record.postal_code      = @text
        when 'CITY':      @int_record.locality         = @text
        when 'POBOX':     @int_record.extended_address = @text
      end
    end
  end
end
