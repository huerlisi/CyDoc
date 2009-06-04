class Invoice < ActiveRecord::Base
  belongs_to :tiers
  belongs_to :law
  belongs_to :treatment

  named_scope :prepared, :conditions => "state = 'prepared'"
  named_scope :open, :conditions => "state = 'open'"

  has_and_belongs_to_many :service_records, :order => 'tariff_type, date DESC'

  def to_s
    "#{patient.name} ##{id}, #{date.strftime('%d.%m.%Y')} à #{sprintf('%0.2f', rounded_amount)} CHF"
  end
  
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

  # Search
  def self.clever_find(query, args = {})
    return [] if query.nil? or query.empty?

    Patient.clever_find(query).collect{|patient| patient.invoices}.flatten
  end
  
  # Calculated fields
  def amount_mt(tariff_type = nil, options = {})
    options.merge!(:conditions => {:tariff_type => tariff_type}) if tariff_type
    service_records.sum('truncate(quantity * amount_mt * unit_factor_mt * unit_mt + 0.005, 2)', options).to_f
  end
  
  def amount_tt(tariff_type = nil, options = {})
    options.merge!(:conditions => {:tariff_type => tariff_type}) if tariff_type
    service_records.sum('truncate(quantity * amount_tt * unit_factor_tt * unit_tt + 0.005, 2)', options).to_f
  end
  
  def amount(tariff_type = nil, options = {})
    amount_mt(tariff_type, options) + amount_tt(tariff_type, options)
  end

  def rounded_amount
    if amount.nil?
      return 0
    else
      return amount.currency_round
    end
  end

  # Generalization
  def date
    created_at.to_date
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
    return "#{esr9_add_validation_digit(amount_string)}>#{esr9_add_validation_digit(id_string)}+&nbsp;#{biller_string}>"
  end
end
