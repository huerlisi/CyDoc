module Praxidata
  class Praxidata::TarBloecke < Base
    set_table_name "TtarBlöcke"
    set_primary_key "IDBlock"

    has_many :service_items, :class_name => 'TarBlockLeistung', :foreign_key => 'inBlockID'

    def self.int_class
      ::TariffItemGroup
    end

    def self.import_record(a, options)
      int_record = int_class.new(
        :code        => a.txErfassungscode.strip,
        :remark      => a.txBezeichnung.strip,
        :tariff_type => '000'
      )

      int_record.service_items = a.service_items.map {|item|
        tariff_item = TariffItem.find_by_code(item.txCode)

        if tariff_item.nil?
          puts "    Skipping missing tariff #{item.txCode}"
        else
          service_item = int_record.service_items.build(
            :tariff_item => tariff_item,
            :quantity    => item.dbAnzahl,
  #          :ref_code    => item.tx_Referenzcode,
            :position    => item.shSortOrder
          )
        end
      }.compact

      return int_record
    end
  end
end
