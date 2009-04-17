module Medindex
  class Article < Base
    def self.int_class
      DrugArticle
    end
    
    def self.lookup_vat_class(code)
      case code
        when '1': VatClass.full
        when '2': VatClass.reduced
        when '3': VatClass.excluded
      end
    end

    def self.import_record(ext_record)
      int_record = int_class.new
      
      int_record.code = ext_record.field('PHAR')
      int_record.group_code = ext_record.field('GRPCD') # TODO: Language support
      int_record.assort_key1 = ext_record.field('CDSO1')
      int_record.assort_key2 = ext_record.field('CDSO2')
      int_record.drug_product_id = ext_record.field('PRDNO')
      int_record.swissmedic_cat = ext_record.field('SMCAT')
      int_record.swissmedic_no = ext_record.field('SMNO')
      int_record.hospital_only = ext_record.field('HOSPCD') == 'Y'
      int_record.clinical = ext_record.field('CLINCD') == 'Y'
      int_record.article_type = ext_record.field('ARTTYP')
      int_record.vat_class = lookup_vat_class(ext_record.field('VAT'))
      int_record.active = ext_record.field('SALECD') == 'N'
      int_record.insurance_limited = ext_record.field('INSLIM') == 'Y'
      int_record.insurance_limitation_points = ext_record.field('LIMPTS').to_f
      int_record.grand_frere = ext_record.field('GRDFR') == 'Y' # A smaller package may be payed by insurance
      int_record.stock_fridge = ext_record.field('COOL') == '1'
      int_record.stock_temperature = ext_record.field('TEMP') # TODO: Should be range
      int_record.narcotic = ext_record.field('CDBG') # TODO: check boolean
      int_record.under_bg = ext_record.field('BG') == 'Y'
      int_record.expires = ext_record.field('EXP').to_i
      int_record.quantity = ext_record.field('QTY').to_f
      int_record.description = ext_record.field('DSCRD') # TODO: Language support
      int_record.name = ext_record.field('SORTD')# TODO: Language support
      int_record.quantity_unit = ext_record.field('QTYUD') # TODO: Language support
      int_record.package_type = ext_record.field('PCKTYPD') # TODO: Language support
      int_record.multiply = ext_record.field('MULT')
      int_record.alias = ext_record.field('SYN1D') # TODO: Language support
      int_record.higher_co_payment = ext_record.field('SLOPLUS')
      int_record.number_of_pieces = ext_record.field('NOPCS').to_i
      
      # Prices
      ext_record.each_element('ARTPRI') { |ext_price|
        int_price = DrugPrice.new
        int_price.valid_from = ext_price.field('VDAT').to_date
        int_price.price = ext_price.field('PRICE').to_f
        int_price.price_type = ext_price.field('PTYP')

        int_price.drug_article = int_record

        int_price.save!
      }
       
      return int_record
    end
  end
end

