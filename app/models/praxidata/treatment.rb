module Praxidata
  module Treatment
    def import(import_record)
      self.attributes = {
        :date_begin => import_record.dtBeginn,
        :date_end   => import_record.dtEnde,
        :patient    => ::Patient.find_or_import(import_record.stamm)
      }
      
      for sitzung in import_record.sitzungen
        self.sessions << ::Session.find_or_import(sitzung)
      end
      
      self.save

      return self
    end
  end
end

Treatment.send :include, Praxidata::Import, Praxidata::Treatment
