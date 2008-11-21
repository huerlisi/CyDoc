class Praxistar::TariffItemGroupProxy < Praxistar::Base
  set_table_name "Tarife_Blöcke"
  set_primary_key "ID_Block"

  def self.hozr_model
    TariffItemGroup
  end

  def self.import_attributes(a)
    {
      :code => a.tx_Erfassungscode,
      :name => a.tx_Bezeichnung
   }
  end

  def self.export_attributes(hozr_record, new_record)
    {
      :tx_Erfassungscode => hozr_record.code,
      :tx_Bezeichnung => hozr_record.name
    }
  end
end
