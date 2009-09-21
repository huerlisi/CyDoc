module Praxidata
  class BelBelege < Base
    set_table_name "TbelBelege"
    set_primary_key "IDBeleg"

    belongs_to :fall, :class_name => 'BelFaelle', :foreign_key => 'inFallID'
    belongs_to :neuer_beleg, :class_name => 'BelBelege', :foreign_key => 'inBelegID'
    belongs_to :kanton, :class_name => 'BelFaelle', :foreign_key => 'inKantonID'
    belongs_to :gesetz, :class_name => 'BelFaelle', :foreign_key => 'shGesetzID'

    def self.int_class
      ::Invoice
    end

    def self.import_record(a, options)
      # shGesetzID: 1 => Krankheit
      # status: 1 => bezahlt
      # shVergütungsart: 1 => Tarif Garant
      # shRechnungsart: 3 =>
      # shBehandlungsgrund: 1 =>
      # shErbringungsort: 1 => Praxis
      # tfKorrekturKostenträger: 0, ''
      # inLaufzeit: mostly 0, second most: 30, up to 200...

      int_record = int_class.new(
        :remark => a.txBemerkung,
        :law => LawKvg.new,
        # :treatment => a.fall,
        :place_type => 'praxis',
        # :state => a.shStatus,
        :value_date => a.dtRechnung,
        :due_date => a.dtRechnung + a.inZahlungsfrist
      )

      unless a.txStornoGrund.blank?
        int_record.state = 'cancelled'
        int_record.remark ||= ''
        int_record.remark += "Storniert: #{a.txStornoGrund}"
      end
      
      int_record.treatment = Treatment.find_by_imported_id(a.fall.id)
      
      int_record.imported_id = a.id

      return int_record
    end
  end
end
