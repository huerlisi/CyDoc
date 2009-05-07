module Medindex
  class Substance < Listener
    def int_class
      Kernel::DrugSubstance
    end

    def tag_start(name, attrs)
      @attribute = nil
      case name
        when 'SB': @record = int_class.new

        when 'SUBNO': @attribute = :id
        when 'NAMD': @attribute = :name
      end
    end
    
    def tag_end(name)
      @attribute = nil
      case name
        when 'SB':
          @record.save!
          puts @record
      end
    end
  end
end

