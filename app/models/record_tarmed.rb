class RecordTarmed < ActiveRecord::Base
  def self.new(code)
    record = super()
    leistung = Tarmed::Leistung.find(code)
    
    record.code = code
    record.amount_mt = leistung.amount_mt
    record.unit_factor_mt = leistung.unit_factor_mt
    record.amount_tt = leistung.amount_tt
    record.unit_factor_tt = leistung.unit_factor_tt
    
    return record
  end
end
