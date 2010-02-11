module Medindex
  class Product < Listener
    # Meta info
    def int_class
      Kernel::DrugProduct
    end

    # Stream handlers
    def tag_start(name, attrs)
      case name
        when 'PRD':
          @int_record = int_class.new
      end
      @text = ""
    end

    def tag_end(name)
      case name
        when 'PRD':
          @int_record.save!
          puts @int_record
          
        when 'PRDNO':    @int_record.id                      = @text.to_i
        when 'DSCRD':    @int_record.description             = @text
        when 'BNAMD':    @int_record.name                    = @text
        when 'ADNAMD':   @int_record.second_name             = @text
        when 'SIZE':     @int_record.size                    = @text
        when 'ADINFOD':  @int_record.info                    = @text
        when 'GENCD':    @int_record.original                = @text == 'O'
        when 'GENGRP':   @int_record.generic_group           = @text
        when 'ATC1':     @int_record.drug_code1_id           = @text
        when 'ATC2':     @int_record.drug_code2_id           = @text
        when 'IT1':      @int_record.therap_code1_id         = @text
        when 'IT2':      @int_record.therap_code2_id         = @text
        when 'KONO':     @int_record.drug_compendium_id      = @text.to_i
        when 'IDXIND':   @int_record.application_code        = @text
        when 'DDDD':     @int_record.dose_amount             = @text.to_f
        when 'DDDU':     @int_record.dose_units              = @text
        when 'DDDA':     @int_record.dose_application        = @text
        when 'IXREL':    @int_record.interaction_relevance   = @text.to_i
        when 'TRADE':    @int_record.active                  = @text == 'iH'
        when 'PRTNO':    @int_record.partner_id              = @text.to_i
        when 'MONO':     @int_record.drug_monograph_id       = @text.to_i
        when 'CDGALD':   @int_record.galenic                 = @text == 'Y'
        when 'GALF':     @int_record.galenic_code_id         = @text
        when 'DOSE':     @int_record.concentration           = @text.to_f
        when 'DOSEU':    @int_record.concentration_unit      = @text
        when 'DRGGRPCD': @int_record.special_drug_group_code = @text
        when 'DRGFD':    @int_record.drug_for                = @text
        when 'PRBSUIT':  @int_record.probe_suited            = @text == 'yes'
        # TODO: *SOL* attributes not implemented
        when 'LSPNSOL':  @int_record.life_span               = @text.to_f
        when 'APDURSOL': @int_record.application_time        = @text.to_f
        when 'EXCIP':    @int_record.excip_text              = @text
        when 'EXCIPQ':   @int_record.excip_quantity          = @text
        when 'EXCIPCD':  @int_record.excip_comment           = @text
     end
    end
  end
end
