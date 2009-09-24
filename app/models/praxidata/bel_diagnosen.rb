module Praxidata
  class BelDiagnosen < Base
    set_table_name "TbelDiagnosen"
    set_primary_key "IDDiagnose"

    belongs_to :fall, :class_name => 'BelFaelle', :foreign_key => 'inFallID'
    belongs_to :diagnose, :class_name => 'DiaPositionen', :foreign_key => 'inDiagnosenID'
    
    # shRechnungscode: 2 => all
    # tfStammdiagnose: 0 => all but one, 1 => single
    # snCodeSystem:    7 => all
    
    def diagnosen_typ
      case snCodeSystem
        when 7.0: DiagnosisByContract
      end
    end
  end
end
