module Praxistar
  class LeistungenDaten < Base
    set_table_name "Leistungen_Daten"
    set_primary_key "ID_Leistungsdaten"

    def tarmed_leistung=(leistung_zuordnung)
      leistung = leistung_zuordnung.tarmed_leistung
      self.tx_Tarifcode = leistung.LNR
      self.tx_Fakturatext = leistung.name
      self.sg_Taxpunkte_TL = leistung.TP_TL
      self.sg_Taxpunkte = leistung.TP_AL
      self.sg_ALZeit = leistung.duration
      self.sg_Faktor_AL = leistung.F_AL
      self.sg_Faktor_TL = leistung.F_TL
      self.tx_Referenzcode = leistung_zuordnung.parent.LNR unless leistung_zuordnung.parent.nil?
    end

    def tx_Tarifcode=(value)
      self.tx_Code1 = value.delete('.')
      write_attribute(:tx_Tarifcode, value)
    end
  end
end

