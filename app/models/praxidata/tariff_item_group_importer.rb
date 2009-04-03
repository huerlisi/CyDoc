class Praxidata::TariffItemGroupImporter < Praxidata::Base
  set_table_name "TtarBlöcke"
  set_primary_key "IDBlock"

  has_many :items, :class_name => 'TarifeBlockliste', :foreign_key => 'Block_ID'

  def self.import(selection = :all)
    for tariff_item_group in find(selection)
      begin
        tariff_group_item = TariffItemGroup.new

        tariff_group_item.code = tariff_item_group.txErfassungscode
        tariff_group_item.remark = tariff_item_group.txBezeichnung

        tariff_group_item.save

#        for tariff_item in tariff_item_group.items
          # Note: this is just educated guessing
#          tarif_position = TariffItemImporter.find(:first, :conditions => {:tx_Erfassungscode => tariff_item.tx_Code1})
#          tariff_group_item.tariff_items << TariffItem.find_by_code(tarif_position.tx_Tarifcode)
#        end

        print "ID: #{tariff_item_group.id} OK\n"
      rescue Exception => ex
        print "ID: #{tariff_item_group.id} => #{ex.message}\n\n"
      end
    end
  end
end
