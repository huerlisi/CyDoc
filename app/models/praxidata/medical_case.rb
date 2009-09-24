module Praxidata
  module MedicalCase
    def import(import_record)
      self.type = 'DiagnosisCase'
      self.save
      self.reload
      
      puts import_record.inspect
      puts import_record.diagnose.txCode
      puts self.inspect
      
      attributes = {
        :duration_from => import_record.fall.dtBeginn,
        :duration_to   => import_record.fall.dtEnde,
        :diagnosis     => import_record.diagnosen_typ.find_by_code(import_record.diagnose.txCode)
      }
      
      self.save
      return self
    end
  end
end

MedicalCase.send :include, Praxidata::Import, Praxidata::MedicalCase
