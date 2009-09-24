module Praxidata
  module Treatment
    def import(import_record)
      self.attributes = {
        :date_begin => import_record.dtBeginn,
        :date_end   => import_record.dtEnde,
        :canton     => import_record.abrechnungsmodus.kanton.to_s,
        :reason     => import_record.abrechnungsmodus.behandlungsgrund,
        :patient    => ::Patient.find_or_import(import_record.stamm),
        :law        => import_record.abrechnungsmodus.gesetz.new(
          :case_date => import_record.dtEreignis,
          :case_id   => import_record.txFalllNummerVersicherung
        )
      }
      
      for sitzung in import_record.sitzungen
        self.sessions << ::Session.find_or_import(sitzung)
      end
      
      for diagnose in import_record.diagnosen
        self.medical_cases << ::DiagnosisCase.find_or_import(diagnose)
      end
      
      self.save
      return self
    end
  end
end

Treatment.send :include, Praxidata::Import, Praxidata::Treatment
