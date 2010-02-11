module Medindex
  class Substance < Listener
    # Meta info
    def int_class
      Kernel::DrugSubstance
    end

    # Stream handlers
    def tag_start(name, attrs)
      case name
        when 'SB':
          @int_record = int_class.new
      end
      @text = ""
    end

    def tag_end(name)
      case name
        when 'SB':
          @int_record.save!
          puts @int_record
          
        when 'SUBNO': @int_record.id   = @text.to_i
        when 'NAMD':  @int_record.name = @text
      end
    end
  end
end

