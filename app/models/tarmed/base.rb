class Tarmed::Base < ActiveRecord::Base
  use_db :prefix => "tarmed_"

  def self.condition_validity
    "GUELTIG_BIS = '2199-12-31 00:00:00'"
  end

  def lang
    'D'
  end

  def self.import_all
    for tarmed_tariff_item in Tarmed::Leistung.find(:all, :conditions => self.condition_validity)
      begin
        tariff_item = TarmedTariffItem.new

        tariff_item.code = tarmed_tariff_item.code
        tariff_item.amount_mt = tarmed_tariff_item.amount_mt
        tariff_item.amount_tt = tarmed_tariff_item.amount_tt
        tariff_item.remark = tarmed_tariff_item.name
        
        tariff_item.save
        print "ID: #{tarmed_tariff_item.id} OK\n"
      rescue Exception => ex
        print "ID: #{tarmed_tariff_item.id} => #{ex.message}\n\n"
      end
    end

    return TarmedTariffItem.count
  end
end
