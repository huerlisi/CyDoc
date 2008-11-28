class Praxistar::TariffItemGroupProxy < Praxistar::Base
  set_table_name "Tarife_Blöcke"
  set_primary_key "ID_Block"

  def self.hozr_model
    TariffItemGroup
  end

  def self.import_attributes(a)
    tariff_item_codes = TariffItemGroupsTariffItemsProxy.find_all_by_Block_ID(a.id).map{|rec| rec.tx_Code1}
    tariff_items = Tarmed::Leistung.find(:all, :conditions => ["replace(LNR, '.', '') IN (?)", tariff_item_codes])
    {
      :code => a.tx_Erfassungscode,
      :name => a.tx_Bezeichnung,
      :tariff_item_ids => tariff_items
   }

  end

  def self.export_attributes(hozr_record, new_record)
    {
      :tx_Erfassungscode => hozr_record.code,
      :tx_Bezeichnung => hozr_record.name
    }
  end
end
