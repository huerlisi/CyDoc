module Praxidata
  class BelBelege < Base
    set_table_name "TbelBelege"
    set_primary_key "IDBeleg"

    belongs_to :fall, :class_name => 'BelFaelle', :foreign_key => 'inFallID'
    belongs_to :neuer_beleg, :class_name => 'BelBelege', :foreign_key => 'inBelegID'
    belongs_to :kanton, :class_name => 'BelFaelle', :foreign_key => 'inKantonID'
    belongs_to :gesetz, :class_name => 'BelFaelle', :foreign_key => 'shGesetzID'

    has_many :sitzungen, :class_name => 'BelSitzungen', :foreign_key => 'inBelegID'
    has_many :debitoren, :class_name => 'FinDebitoren', :foreign_key => 'inBelegID'
    has_many :zahlungen, :class_name => 'FinZahlungen', :foreign_key => 'inBelegID'

    # shGesetzID: 1 => Krankheit
    # shStatus: 1 => aktiv, 2 => storniert, 3 => reaktiviert
    # shVergütungsart: 1 => Tarif Garant
    # shRechnungsart: 3 =>
    # shBelegArt: 3 => Rechnung, 2 => Leistungsblatt
    # shBehandlungsgrund: 1 =>
    # shErbringungsort: 1 => Praxis
    # tfKorrekturKostenträger: 0, ''
    # inLaufzeit: mostly 0, second most: 30, up to 200...
    
    def status
      case shStatus
        when 1: 'prepared'
        when 2: 'canceled'
        when 3: 'reactivated'
      end
    end
  end
end
