module Praxidata
  module DiagnosisCase
    def import(import_record)
      puts import_record.inspect
      puts import_record.diagnose.txCode
      puts self.inspect
      puts import_record.diagnosen_typ.to_s
      puts import_record.diagnosen_typ.find_by_code(import_record.diagnose.txCode).inspect
      
      attributes = {
        :duration_from => import_record.fall.dtBeginn,
        :duration_to   => import_record.fall.dtEnde,
      }
      self.diagnosis = import_record.diagnosen_typ.find_by_code(import_record.diagnose.txCode)
      
      self.save
      return self
    end
  end
end

DiagnosisCase.send :include, Praxidata::Import, Praxidata::DiagnosisCase
