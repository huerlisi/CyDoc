class Tarmed::Importer
  def self.import
    for tarmed_tariff_item in Tarmed::Leistung.find(:all)
      begin
        tariff_item = TarmedTariffItem.new

        tariff_item.code = tarmed_tariff_item.code
        tariff_item.amount_mt = tarmed_tariff_item.amount_mt
        tariff_item.amount_tt = tarmed_tariff_item.amount_tt
        tariff_item.remark = tarmed_tariff_item.name
        
        tariff_item.save
        print "ID: #{tarmed_tariff_item} OK"
      rescue Exception => ex
        print "ID: #{tarmed_tariff_item.id} => #{ex.message}\n\n"
      end
    end
  end
end
