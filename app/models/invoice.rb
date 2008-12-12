class Invoice < ActiveRecord::Base
  belongs_to :tiers
  belongs_to :law
  belongs_to :treatment

  has_and_belongs_to_many :service_records, :after_add => :add_service_record

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
    service_records.sum('quantity * amount_mt * unit_factor_mt').to_f * 0.89
  end
  
  def amount_tt
    # TODO: unit_tt's no constant
    service_records.sum('quantity * amount_tt * unit_factor_tt').to_f * 0.89
  end
  
  def amount
    amount_mt + amount_tt
  end

  def rounded_amount
    if amount.nil?
      return 0
    else
      return (amount * 20).round / 20.0
    end
  end

  # Generalization
  def date
    created_at
  end

  def date=(value)
    write_attribute(:created_at, value)
  end

  def esr9(bank_account)
    esr9_build(rounded_amount, id, bank_account.pc_id, bank_account.esr_id) # TODO: it's biller.esr_id
  end

  def esr9_reference(bank_account)
    esr9_format(esr9_add_validation_digit(sprintf(bank_account.esr_id + '%020i', id)))
  end

  private
  # Association callbacks
  def add_service_record(service_record)
    return true if treatment.nil?
    
    # Expand treatmend duration to include this tarmed record
    treatment.date_begin = service_record.date if (treatment.date_begin.nil? or service_record.date < treatment.date_begin)
    treatment.date_end = service_record.date if (treatment.date_end.nil? or service_record.date > treatment.date_end)

    # Add diagnoses on the same as this tarmed record
    diagnose_cases = DiagnosisCase.find(:all, :conditions => {:patient_id => patient.id, :duration_to => service_record.date})
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

  def esr9_format(reference_code)
    # Drop all leading zeroes
    reference_code.gsub!(/^0*/, '')

    # Group by 5 digit blocks, beginning at the right side
    reference_code.reverse.gsub(/(.....)/, '\1 ').reverse
  end

  def esr9_format_account_id(account_id)
    (pre, main, post) = account_id.split('-')
    sprintf('%02i%06i%1i', pre, main, post)
  end

  def esr9_build(amount, id, biller_id, esr_id)
    # 01 is type 'Einzahlung in CHF'
    amount_string = "01#{sprintf('%011.2f', amount).delete('.')}"

    id_string = esr_id + sprintf('%020i', id).delete(' ')

    biller_string = esr9_format_account_id(biller_id)
    return "#{esr9_add_validation_digit(amount_string)}>#{esr9_add_validation_digit(id_string)}+ #{biller_string}>"
  end
end
