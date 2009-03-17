class Praxidata::ServiceRecordImporter
  def self.import(mandant_id)
    for praxistar_services in Praxidata::LeistungenBlatt.find(:all, :conditions => {:Mandant_ID => mandant_id})
      import_records(praxistar_services)
    end
  end
  
  def self.import_records(leistungen_blatt)
    for praxistar_service_record in leistungen_Blatt.leistungen_daten
      service_record = ServiceRecord.new

      service_record.treatment = praxistar_service_record.
      service_record.tariff_type = praxistar_service_record.tx_Tarifnummer
      service_record.tariff_version = praxistar_service_record.
      service_record.contract_number = praxistar_service_record.
      service_record.code = praxistar_service_record.tx_Tarifcode
      service_record.ref_code = praxistar_service_record.tx_Referenzcode
      service_record.session = praxistar_service_record.sg_Session
      service_record.quantity = praxistar_service_record.sg_Anzahl
      service_record.date = praxistar_service_record.dt_Erfassungsdatum
      service_record.provider_id = praxistar_service_record.Leistungserbringer_ID
      service_record.responsible = praxistar_service_record.
      service_record.location = praxistar_service_record.
      service_record.billing_role = praxistar_service_record.
      service_record.medical_role = praxistar_service_record.
      service_record.body_location = praxistar_service_record.
      service_record.unit_factor_mt = praxistar_service_record.sg_Faktor_AL
      service_record.scale_factor_mt = praxistar_service_record.
      service_record.external_factor_mt = praxistar_service_record.
      service_record.amount_mt = praxistar_service_record.sg_Taxpunkte_TL
      service_record.unit_factor_tt = praxistar_service_record.sg_Faktor_TL
      service_record.scale_factor_tt = praxistar_service_record.
      service_record.external_factor_tt = praxistar_service_record.
      service_record.amount_tt = praxistar_service_record.sg_Taxpunkte
      service_record.vat_rate = praxistar_service_record.
      service_record.splitting_factor = praxistar_service_record.
      service_record.validate = praxistar_service_record.
      service_record.obligation = !(praxistar_service_record.tf_Nichtpflichtleistung)
      service_record.section_code = praxistar_service_record.
      service_record.remark = praxistar_service_record.tx_Fakturatext
      service_record.created_at = praxistar_service_record.dt_Erfassungsdatum
      service_record.updated_at = praxistar_service_record.dt_Mutationsdatum
      service_record.patient = praxistar_service_record.
      service_record.unit_mt = praxistar_service_record.cu_Taxpunktwert_AL  
      service_record.unit_tt = praxistar_service_record.cu_Taxpunktwert_TL
    end
  end
end
