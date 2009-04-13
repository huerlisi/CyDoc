module Medindex
  class Product < Base
    def self.int_class
      Kernel::DrugProduct
    end

    def self.import_record(ext_record)
      int_record = self.int_class.new
      
      int_record.id = ext_record.field('PRODNO')
      int_record.description = ext_record.field('DSCRD') # TODO: Language support
      int_record.name = ext_record.field('BNAMD') # TODO: Language support
      int_record.second_name = ext_record.field('ADNAMD') # TODO: Language support
      int_record.size = ext_record.field('SIZE')
      int_record.info = ext_record.field('ADINFOD') # TODO: Language support
      int_record.original = ext_record.field('GENCD') == 'O'
      int_record.generic_group = ext_record.field('GENGRP')
      int_record.drug_code1_id = ext_record.field('ATC1')
      int_record.drug_code2_id = ext_record.field('ATC2')
      int_record.therap_code1_id = ext_record.field('IT1')
      int_record.therap_code2_id = ext_record.field('IT2')
      int_record.drug_compendium_id = ext_record.field('KONO').to_i
      int_record.application_code = ext_record.field('IDXIND')
      int_record.dose_amount = ext_record.field('DDDD').to_f
      int_record.dose_units = ext_record.field('DDDU')
      int_record.dose_application = ext_record.field('DDDA')
      int_record.interaction_relevance = ext_record.field('IXREL').to_i
      int_record.active = ext_record.field('TRADE') == 'iH'
      int_record.partner_id = ext_record.field('PRTNO').to_i
      int_record.drug_monograph_id = ext_record.field('MONO').to_i
      int_record.galenic = ext_record.field('CDGALD') # TODO: Language support
      int_record.concentration = ext_record.field('DOSE').to_f
      int_record.concentration_unit = ext_record.field('DOSEU')
      int_record.special_drug_group_code = ext_record.field('DRGGRPCD')
      int_record.drug_for = ext_record.field('DRGFD') # TODO: Language support
      int_record.probe_suited = ext_record.field('PRBSUIT') == 'yes'
      # TODO: *SOL* attributes not implemented
      int_record.life_span = ext_record.field('LSPNSOL').to_f
      int_record.application_time = ext_record.field('APDURSOL').to_f
      int_record.excip_text = ext_record.field('EXCIP')
      int_record.excip_quantity = ext_record.field('EXCIPQ')
      int_record.excip_comment = ext_record.field('EXCIPCD')

      return int_record
    end
  end
end

