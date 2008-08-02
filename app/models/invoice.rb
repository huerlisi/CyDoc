class Invoice < ActiveRecord::Base
  belongs_to :tiers
  belongs_to :law
  belongs_to :treatment

  has_and_belongs_to_many :record_tarmeds, :after_add => :add_record_tarmed

  # Convenience methods
  def biller
    tiers.biller
  end

  def provider
    tiers.provider
  end

  def insurance
    tiers.insurance
  end

  def patient
    tiers.patient
  end

  def referrer
    tiers.provider
  end

  def employer
    tiers.employer
  end

  def case_id
    law.case_id
  end

  # Calculated fields
  def amount_mt
    # TODO: unit_mt's no constant
    record_tarmeds.sum('quantity * amount_mt * unit_factor_mt').to_f * 0.89
  end
  
  def amount_tt
    # TODO: unit_tt's no constant
    record_tarmeds.sum('quantity * amount_tt * unit_factor_tt').to_f * 0.89
  end
  
  def amount
    amount_mt + amount_tt
  end

  # Generalization
  def date
    created_at
  end

  def date=(value)
    write_attribute(:created_at, value)
  end

  def esr9
    esr9_build(amount, id, '01-200027-2') # TODO: it's biller.esr_id
  end

  private
  # Association callbacks
  def add_record_tarmed(record_tarmed)
    return true if treatment.nil?
    
    # Expand treatmend duration to include this tarmed record
    treatment.date_begin = record_tarmed.date if (treatment.date_begin.nil? or record_tarmed.date < treatment.date_begin)
    treatment.date_end = record_tarmed.date if (treatment.date_end.nil? or record_tarmed.date > treatment.date_end)

    # Add diagnoses on the same as this tarmed record
    diagnose_cases = DiagnosisCase.find(:all, :conditions => {:patient_id => patient.id, :duration_to => record_tarmed.date})
    treatment.diagnoses << diagnose_cases.map{|d| d.diagnosis}
  end

  # ESR helpers
  def esr9_add_validation_digit(value)
    # Defined at http://www.pruefziffernberechnung.de/E/Einzahlungsschein-CH.shtml
    esr9_table = [0, 9, 4, 6, 8, 2, 7, 1, 3, 5]
    
    digit = 0
    value.split('').map{|c| digit = esr9_table[(digit + c.to_i) % 10]}
    
    digit = (10 - digit) % 10
    return "#{value}#{digit}"
  end

  def esr9_build(amount, id, biller_id)
    # 01 is type 'Einzahlung in CHF'
    amount_string = "01#{sprintf('%011.2f', amount).delete('.')}"

    id_string = sprintf('%015i', id).delete(' ')

    biller_string = biller_id.delete('-')
    return "#{esr9_add_validation_digit(amount_string)}>#{esr9_add_validation_digit(id_string)}+ #{biller_string}>"
  end
end
