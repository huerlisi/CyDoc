module Praxidata
  module Session
    def import(import_record)
      self.attributes = {
        :duration_from => import_record.dtSitzung,
        :duration_to   => import_record.dtSitzung,
      }
      
      for position in import_record.positionen
        self.service_records << ::ServiceRecord.find_or_import(position)
      end

      self.save

      return self
    end
  end
end

Session.send :include, Praxidata::Import, Praxidata::Session
