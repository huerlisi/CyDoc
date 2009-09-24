module Praxidata
  class ModAbrechnungsmodus < Base
    set_table_name "TModAbrechnungsmodus"
    set_primary_key "IDModus"
    
    belongs_to :kanton, :class_name => 'SysKantone', :foreign_key => 'inKantonID'
    belongs_to :erbringungsort, :class_name => 'AdrStamm', :foreign_key => 'inErbringungsortStammID'

    # shGesetz:              1 => KVG, 2 => UVG, 3 => IV, 4 => MV
    # shVorgabeversicherung: 1 => KVG, 2 => UVG, 3 => MV, 4 => IV
    # shVergütungsart:       1 => TG, 2 => TP ???
    # shRechnungsart:        3 => alle ???
    # shBehandlungsgrund:    1 => Krankheit, 2 => Unfall
    # shBehandlungsart:      1 => alle (ambulant?)
    # shErbringungsort:      1 => Praxis, 2 => Spital
    # shBelegart:            2 => alle
    # shDistribution:        '' => alle
    # shRechnungsoutput:     1 => alle

    def behandlungsgrund
      case shBehandlungsgrund
        when 1: "Krankheit"
        when 2: "Unfall"
      end
    end

    def gesetz
      case shGesetz
        when 1: LawKvg
        when 2: LawUvg
        when 3: LawIvg
        when 4: LawMvg
      end
    end
  end
end
