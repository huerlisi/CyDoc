module Medindex
  class Article < Listener
    # Meta info
    def self.int_class
      Kernel::DrugArticle
    end
    
    def record_name
      'ART'
    end
    
    # Lookup helper
    def lookup_vat_class(code)
      case code
        when '1': return VatClass.full
        when '2': return VatClass.reduced
        when '3': return VatClass.excluded
      end
    end

    # Stream handlers
    def tag_start(name, attrs)
      super

      case name
        when 'ARTPRI': @price = @int_record.drug_prices.build
      end
    end

    def tag_end(name)
      super

      case name
        when 'PHAR':    @int_record.code                        = @text
        when 'GRPCD':   @int_record.group_code                  = @text # TODO: Language support
        when 'CDSO1':   @int_record.assort_key1                 = @text
        when 'CDSO2':   @int_record.assort_key2                 = @text
        when 'PRDNO':   @int_record.drug_product_id             = @text
        when 'SMCAT':   @int_record.swissmedic_cat              = @text
        when 'SMNO':    @int_record.swissmedic_no               = @text
        when 'HOSPCD':  @int_record.hospital_only               = @text == 'Y'
        when 'CLINCD':  @int_record.clinical                    = @text == 'Y'
        when 'ARTTYP':  @int_record.article_type                = @text
        when 'VAT':     @int_record.vat_class                   = lookup_vat_class(@text.strip)
        when 'SALECD':  @int_record.active                      = @text == 'N'
        when 'INSLIM':  @int_record.insurance_limited           = @text == 'Y'
        when 'LIMPTS':  @int_record.insurance_limitation_points = @text.to_f
        when 'GRDFR':   @int_record.grand_frere                 = @text == 'Y' # A smaller package may be payed by insurance
        when 'COOL':    @int_record.stock_fridge                = @text == '1'
        when 'TEMP':    @int_record.stock_temperature           = @text # TODO: Should be range
        when 'CDBG':    @int_record.narcotic                    = @text # TODO: check boolean
        when 'BG':      @int_record.under_bg                    = @text == 'Y'
        when 'EXP':     @int_record.expires                     = @text.to_i
        when 'QTY':     @int_record.quantity                    = @text.to_f
        when 'DSCRD':   @int_record.description                 = @text # TODO: Language support
        when 'SORTD':   @int_record.name                        = @text # TODO: Language support
        when 'QTYUD':   @int_record.quantity_unit               = @text # TODO: Language support
        when 'PCKTYPD': @int_record.package_type                = @text # TODO: Language support
        when 'MULT':    @int_record.multiply                    = @text
        when 'SYN1D':   @int_record.alias                       = @text # TODO: Language support
        when 'SLOPLUS': @int_record.higher_co_payment           = @text
        when 'NOPCS':   @int_record.number_of_pieces            = @text.to_i
      # Prices
        when 'ARTPRI':  @price.save!
        when 'VDAT':    @price.valid_from                       = @text.to_date
        when 'PRICE':   @price.price                            = @text
        when 'PTYP':    @price.price_type                       = @text
      end
    end
  end
end

