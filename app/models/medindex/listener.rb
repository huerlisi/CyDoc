require 'rexml/streamlistener'

module Medindex
  class Listener
    include REXML::StreamListener
    
    @record = nil
    
    def tag_start(name, attrs)
      @attribute = nil
puts name
      case name
        when 'INS': @record = Kernel::Insurance.new

        when 'EAN': @attribute = :ean_party
        when 'GROUP_EAN': @attribute = :group_ean_party
        when 'ROLE': @attribute = :role
        when 'GROUP_EAN': @attribute = :group_ean_party

        when 'DESCR1': @attribute = :full_name

        when 'ADDR':
          @insurance = @record
          @record = Vcards::Vcard.new

        when 'ZIP': @attribute = :postal_code
        when 'CITY': @attribute = :locality
        when 'POBOX': @attribute = :extended_address

      end
    end
    
    def tag_end(name)
      @attribute = nil
      case name
        when 'INS':
          @record.save!
        when 'ADDR':
          @record.save!
          @record.object = @insurance

          @record = @insurance
      end
    end
    
    def text(content)
      return unless (@record and @attribute)
      @record.send(@attribute.to_s + '=', content)
    end
  end
end
