class Praxidata::TariffeTarifposition < Praxidata::Base
  set_table_name "Tarife_Tarifposition"
  set_primary_key "id_Position"

  def self.import
    for lab_tariff_item in find(:all, :conditions => "Tarif_id = 1")
      begin
        tariff_item = LabTariffItem.new

        tariff_item.code = lab_tariff_item.tx_Tarifcode
        tariff_item.amount_tt = lab_tariff_item.sg_Taxpunkte
        tariff_item.remark = lab_tariff_item.tx_Klartext
        
        tariff_item.save
        print "ID: #{lab_tariff_item.id} OK\n"
      rescue Exception => ex
        print "ID: #{lab_tariff_item.id} => #{ex.message}\n\n"
      end
    end
  end
end
