module Medindex
  class Substance < Listener
    # Meta info
    def self.int_class
      Kernel::DrugSubstance
    end

    def id_element
      'SUBNO'
    end
    
    def record_name
      'SB'
    end

    # Stream handlers
    def tag_end(name)
      super
      
      case name
        when 'SUBNO': @int_record.id   = @text.to_i
        when 'NAMD':  @int_record.name = @text
      end
    end
  end
end

