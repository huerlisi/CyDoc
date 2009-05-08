module Praxistar
  class TarifeBloecke < Base
    set_table_name "Tarife_Blöcke"
    set_primary_key "ID_Block"

    has_many :items, :class_name => 'TarifeBlockliste', :foreign_key => 'Block_ID'

    def self.int_class
      TariffItemGroup
    end
    
    def self.import_record(a, options)
      int_record = int_class.new(
        :code   => a.tx_Erfassungscode.strip,
        :remark => a.tx_Bezeichnung.strip
      )

      int_record.tariff_items = a.items.map {|item|
        ext_tarif_code = TarifeTarifposition.find_by_tx_Erfassungscode(item.tx_Code1).tx_Tarifcode
        
        tariff_item = TariffItem.find_by_code(ext_tarif_code)

        if tariff_item.nil?
          puts "    Skipping #{int_record.code} because of missing tariff #{ext_tarif_code}"
          raise SkipException
        end
        
        tariff_item
      }.compact
      
      return int_record
    end
  end
end
