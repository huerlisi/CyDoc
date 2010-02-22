class Invoice < ActiveRecord::Base
  PAYMENT_PERIOD = 30
  DEBIT_ACCOUNT = Accounting::Account.find_by_code('1100')
  EARNINGS_ACCOUNT = Accounting::Account.find_by_code('3200')
  
  REMINDER_FEE = {'reminded' => 0.0, '2xreminded' => 10.0, '3xreminded' => 10.0, 'encashment' => 100.0}
  REMINDER_PAYMENT_PERIOD = {'reminded' => 20, '2xreminded' => 10, '3xreminded' => 10, 'encashment' => 0}
  
  belongs_to :tiers
  belongs_to :law
  belongs_to :treatment

  # State
  named_scope :prepared, :conditions => "state = 'prepared'"
  named_scope :canceled, :conditions => "state = 'canceled'"
  named_scope :reactivated, :conditions => "state = 'reactivated'"
  named_scope :active, :conditions => "NOT(state IN ('reactivated', 'canceled'))"
  named_scope :open, :conditions => "NOT(state IN ('reactivated', 'canceled', 'paid'))"
  named_scope :overdue, :conditions => ["(state = 'booked' AND due_date < :today) OR (state = 'reminded' AND reminder_due_date < :today) OR (state = '2xreminded' AND second_reminder_due_date < :today)", {:today => Date.today}]
  named_scope :in_encashment, :conditions => ["state = 'encashment'"]

  
  def active
    !(state == 'canceled' or state == 'reactivated')
  end
  
  def open
    active and !(state == 'paid')
  end

  def state_adverb
    case state
      when 'prepared': "offen"
      when 'booked': "verbucht"
      when 'printed': "gedruckt"
      when 'canceled': "storniert"
      when 'reactivated': "reaktiviert"
      when 'reminded': "1x gemahnt"
      when '2xreminded': "2x gemahnt"
      when '3xreminded': "3x gemahnt"
      when 'encashment': "in inkasso"
      when 'paid': "bezahlt"
    end
  end
  
  def state_noun
    case state
      when 'prepared':    "Offene Rechnung"
      when 'booked':      "Verbuchte Rechnung"
      when 'printed':     "Gedruckte Rechnung"
      when 'canceled':    "Stornierte Rechnung"
      when 'reactivated': "Reaktivierte Rechnung"
      when 'reminded':    "1. Mahnung"
      when '2xreminded':  "2. Mahnung"
      when '3xreminded':  "3. Mahnung"
      when 'encashment':  "Inkasso"
      when 'paid':        "Bezahlte Rechnung"
    end
  end
  
  def overdue?
    (state == 'booked' and due_date < Date.today) or (state == 'reminded' and reminder_due_date < Date.today) or (state == '2xreminded' and second_reminder_due_date < Date.today)
  end
  
  def reactivate
    bookings.build(:title => "Storno",
                   :amount => amount.currency_round,
                   :credit_account => EARNINGS_ACCOUNT,
                   :debit_account => DEBIT_ACCOUNT,
                   :value_date => Date.today)
    self.state = 'reactivated'
    # TODO: actually reactivate treatment/session
  end
  
  def cancel
    bookings.build(:title => "Storno",
                   :amount => amount.currency_round,
                   :credit_account => EARNINGS_ACCOUNT,
                   :debit_account => DEBIT_ACCOUNT,
                   :value_date => Date.today)
    self.state = 'canceled'
  end
  
  def build_reminder_booking
    bookings.build(:title => self.state_noun,
                   :amount => REMINDER_FEE[self.state],
                   :credit_account => DEBIT_ACCOUNT,
                   :debit_account => EARNINGS_ACCOUNT,
                   :value_date => Date.today)
  end
  
  def remind
    case state
      when 'booked':      remind_first_time
      when 'reminded':    remind_second_time
#      when '2xreminded':  remind_third_time
      when '2xreminded':  encash
      when '3xreminded':  encash
    end
  end
  
  def remind_first_time
    self.state = 'reminded'
    self.reminder_due_date = Date.today + REMINDER_PAYMENT_PERIOD[self.state]
    build_reminder_booking
  end
  
  def remind_second_time
    self.state = '2xreminded'
    self.second_reminder_due_date = Date.today + REMINDER_PAYMENT_PERIOD[self.state]
    build_reminder_booking
  end
  
  def remind_third_time
    self.state = '3xreminded'
    self.third_reminder_due_date = Date.today + REMINDER_PAYMENT_PERIOD[self.state]
    build_reminder_booking
  end
  
  def encash
    self.state = 'encashment'
    build_reminder_booking
  end
  
  has_and_belongs_to_many :service_records, :order => 'tariff_type, date DESC, if(ref_code IS NULL, code, ref_code), concat(code,ref_code)'

  # Validation
  validates_format_of :value_date, :with => /[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{2,4}/, :message => 'braucht Format dd.mm.yy (z.B. 3.12.1980)'

  validates_presence_of :service_records, :message => 'Keine Leistung eingegeben.'
  validate :valid_service_records?
  
  validates_presence_of :treatment
  validate :valid_treatment?

  validates_presence_of :patient
  validate :valid_patient?
  
  def valid_service_records?
    service_records.map{|service_record|
      errors.add_to_base(service_record.errors.full_messages.join('</li><li>')) unless service_record.valid_for_invoice?
    }

    return errors.empty?
  end
  
  def valid_treatment?
    errors.add_to_base(treatment.errors.full_messages.join('</li><li>')) unless treatment.valid_for_invoice?

    return errors.empty?
  end

  def valid_patient?
    errors.add_to_base(patient.errors.full_messages.join('</li><li>')) unless patient.valid_for_invoice?

    return errors.empty?
  end
  
  # Accounting
  has_many :bookings, :class_name => 'Accounting::Booking', :as => 'reference', :dependent => :destroy
  
  def due_amount(value_date = nil)
    if value_date
      included_bookings = bookings.find(:all, :conditions => ["value_date <= ?", value_date])
    else
      included_bookings = bookings
    end
    included_bookings.to_a.sum{|b| b.accounted_amount(Invoice::DEBIT_ACCOUNT)}
  end
  
  def booking_saved(booking)
    if (self.state != 'canceled') and (due_amount <= 0.0)
      self.state = 'paid'
      self.save
    end
  end
  
  def build_booking
    bookings.build(:title => "Rechnung",
                   :amount => amount.currency_round,
                   :credit_account => DEBIT_ACCOUNT,
                   :debit_account => EARNINGS_ACCOUNT,
                   :value_date => value_date)
  end

  public
  
  # Standard methods
  def to_s(format = :default)
    case format
    when :short
      "##{id}: #{value_date.strftime('%d.%m.%Y') if value_date}"
    else
      "#{patient.name}, Rechnung ##{id} #{value_date.strftime('%d.%m.%Y')} über #{sprintf('%0.2f', rounded_amount)} CHF"
    end
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

  def date_begin
    service_records.minimum(:date).to_date
  end
  
  def date_end
    service_records.maximum(:date).to_date
  end
  
  # Search
  def self.clever_find(query, args = {})
    return [] if query.blank?

    query_params = {}
    case query
    when /^[[:digit:]]*$/
      query_params[:query] = query
      patient_condition = "patients.doctor_patient_nr = :query"
      invoice_condition = "invoices.id = :query OR invoices.imported_invoice_id = :query"
    when /([[:digit:]]{1,2}\.){2}/
      query_params[:query] = Date.parse_europe(query, :past).strftime('%%%y-%m-%d%')
      patient_condition = "patients.birth_date LIKE :query"
      invoice_condition = "invoices.created_at LIKE :query"
    else
      query_params[:query] = "%#{query}%"
      query_params[:wildcard_value] = '%' + query.gsub(/[ -.]+/, '%') + '%'
      name_condition = "(vcards.given_name LIKE :wildcard_value) OR (vcards.family_name LIKE :wildcard_value) OR (vcards.full_name LIKE :wildcard_value)"
      given_family_condition = "( concat(vcards.given_name, ' ', vcards.family_name) LIKE :wildcard_value)"
      family_given_condition = "( concat(vcards.family_name, ' ', vcards.given_name) LIKE :wildcard_value)"

      patient_condition = "#{name_condition} OR #{given_family_condition} or #{family_given_condition}"
      invoice_condition = "invoices.remark LIKE :wildcard_value"
    end

    args.merge!(:include => {:tiers => {:patient => [:vcard]}}, :conditions => ["(#{patient_condition}) OR (#{invoice_condition})", query_params], :order => 'vcards.family_name, vcards.given_name')
    find(:all, args)
  end
  
  # Calculated fields
  def amount_mt(tariff_type = nil, options = {})
    options.merge!(:conditions => {:tariff_type => tariff_type}) if tariff_type
    BigDecimal.new(service_records.sum('truncate(quantity * amount_mt * unit_factor_mt * unit_mt + 0.005, 2)', options) || '0.0')
  end
  
  def amount_tt(tariff_type = nil, options = {})
    options.merge!(:conditions => {:tariff_type => tariff_type}) if tariff_type
    BigDecimal.new(service_records.sum('truncate(quantity * amount_tt * unit_factor_tt * unit_tt + 0.005, 2)', options) || '0.0')
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
    self.value_date
  end

  def date=(value)
    self.value_date = value
  end

  def value_date=(value)
    write_attribute(:value_date, Date.parse_europe(value))
    self.due_date = value_date + PAYMENT_PERIOD unless value_date.nil?
  end
  
  def esr9(bank_account)
    esr9_build(due_amount.currency_round, id, bank_account.pc_id, bank_account.esr_id) # TODO: it's biller.esr_id
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

  public
  def esr9_build(esr_amount, id, biller_id, esr_id)
    # 01 is type 'Einzahlung in CHF'
    amount_string = "01#{sprintf('%011.2f', esr_amount).delete('.')}"

    id_string = esr_id + sprintf('%020i', id).delete(' ')

    biller_string = esr9_format_account_id(biller_id)
    return "#{esr9_add_validation_digit(amount_string)}>#{esr9_add_validation_digit(id_string)}+&nbsp;#{biller_string}>"
  end
end
