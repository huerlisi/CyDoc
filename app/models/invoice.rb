class Invoice < ActiveRecord::Base
  PAYMENT_PERIOD = 30
  DEBIT_ACCOUNT = Account.find_by_code('1100')
  EARNINGS_ACCOUNT = Account.find_by_code('3200')

  REMINDER_FEE = {'reminded' => 0.0, '2xreminded' => 10.0, '3xreminded' => 10.0, 'encashment' => 0.0}
  REMINDER_PAYMENT_PERIOD = {'reminded' => 20, '2xreminded' => 10, '3xreminded' => 10, 'encashment' => 0}
  REMINDER_GRACE_PERIOD = {'reminded' => 30, '2xreminded' => 30, '3xreminded' => 30, 'encashment' => 30}
  
  belongs_to :tiers, :autosave => true
  belongs_to :law, :autosave => true
  belongs_to :treatment, :autosave => true
  has_one :patient, :through => :treatment

  belongs_to :patient_vcard, :class_name => 'Vcard', :autosave => true
  belongs_to :billing_vcard, :class_name => 'Vcard', :autosave => true

  # Treatment hook
  after_save :notify_treatment
  after_destroy :notify_treatment

  def notify_treatment
    treatment.update_state
  end

  # Constructor
  def self.create_from_treatment(treatment, value_date, tiers_name, provider, biller)
    # Prepare Tiers
    tiers = Object.const_get(tiers_name).new(
      :patient  => treatment.patient,
      :provider => provider,
      :biller   => biller,
      :referrer => treatment.referrer
    )

    # Build Invoice
    invoice = self.new(
      :treatment  => treatment,
      :value_date => value_date,
      :tiers      => tiers,
      :law        => treatment.law
    )

    # Assign service records
    sessions = treatment.sessions.open
    invoice.service_records = sessions.collect{|s| s.service_records}.flatten

    invoice.valid? && Invoice.transaction do
      for session in sessions
        session.invoices << invoice
        session.charge
        # Touch session as it won't autosave otherwise
        session.touch
      end

      # Build booking
      invoice.book

      invoice.save
    end

    return invoice
  end

  # Dunning
  named_scope :dunning_stopped, :include => {:treatment => :patient}, :conditions => {"patients.dunning_stop" => true}
  named_scope :dunning_active, :include => {:treatment => :patient}, :conditions => {"patients.dunning_stop" => false}

  # State
  # =====
  named_scope :prepared, :conditions => "invoices.state = 'prepared'"
  named_scope :canceled, :conditions => "invoices.state = 'canceled'"
  named_scope :reactivated, :conditions => "invoices.state = 'reactivated'"
  named_scope :in_encashment, :conditions => ["invoices.state = 'encashment'"]

  named_scope :active, :conditions => "NOT(invoices.state IN ('reactivated', 'canceled', 'written_off'))"
  def active
    !(state == 'canceled' or state == 'reactivated' or state == 'written_off')
  end
  
  named_scope :open, :conditions => "NOT(invoices.state IN ('reactivated', 'canceled', 'written_off', 'paid'))"
  def open
    !(state == 'canceled' or state == 'reactivated' or state == 'written_off' or state == 'paid')
  end

  # TODO: unify greeze period of 30 days and make configurable
  named_scope :overdue, :conditions => ["(invoices.state IN ('booked', 'printed') AND due_date < :today) OR (invoices.state = 'reminded' AND reminder_due_date < :today) OR (invoices.state = '2xreminded' AND second_reminder_due_date < :today) OR (invoices.state = '3xreminded' AND third_reminder_due_date < :today)", {:today => Date.today.ago(30.days)}]
  def overdue?
    return true if (state == 'booked' or state == 'printed') and due_date < Date.today
    return true if state == 'reminded' and (reminder_due_date.nil? or reminder_due_date < Date.today)
    return true if state == '2xreminded' and (second_reminder_due_date.nil? or second_reminder_due_date < Date.today)
    return true if state == '3xreminded' and (third_reminder_due_date.nil? or third_reminder_due_date < Date.today)

    return false
  end

  named_scope :reminded, :conditions => "invoices.state IN ('reminded', '2xreminded', '3xreminded', 'encashment')"
  def reminded?
    return ['reminded', '2xreminded', '3xreminded', 'encashment'].include?(state)
  end

  def state_adverb
    I18n.t state, :scope => 'invoice.state'
  end
  
  def state_noun(for_state = nil)
    for_state ||= state
    case for_state
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
      when 'written_off': "Abgeschriebene Rechnung"
    end
  end
  
  # Actions
  def reactivate
    # TODO: only build booking if booked
    
    unless state == 'canceled'
      # Cancel original amount
      bookings.build(:title => "Storno",
                     :comments => "Reaktiviert",
                     :amount => amount,
                     :credit_account => EARNINGS_ACCOUNT,
                     :debit_account => DEBIT_ACCOUNT,
                     :value_date => Date.today)
      # Cancel reset if needed
      if due_amount > 0
        bookings.build(:title => "Debitorenverlust",
                       :comments => "Reaktiviert",
                       :amount => due_amount,
                       :credit_account => EARNINGS_ACCOUNT,
                       :debit_account => DEBIT_ACCOUNT,
                       :value_date => Date.today)
      end
    end
    
    self.state = 'reactivated'
    # TODO: actually reactivate treatment/session

    for session in sessions
      session.reactivate
    end
    
    return self
  end
  
  def cancel(comments = nil)
    # Cancel original amount
    booking = bookings.build(:title => "Storno",
                   :amount => amount,
                   :credit_account => EARNINGS_ACCOUNT,
                   :debit_account => DEBIT_ACCOUNT,
                   :value_date => Date.today)
    booking.comments = comments if comments.present?

    # Cancel reset if needed
    if due_amount > 0
      bookings.build(:title => "Debitorenverlust",
                     :comments => "Storniert",
                     :amount => due_amount,
                     :credit_account => EARNINGS_ACCOUNT,
                     :debit_account => DEBIT_ACCOUNT,
                     :value_date => Date.today)
    end

    self.state = 'canceled'

    return booking
  end
  
  def build_booking
    bookings.build(:title => "Rechnung",
                   :amount => amount,
                   :credit_account => DEBIT_ACCOUNT,
                   :debit_account => EARNINGS_ACCOUNT,
                   :value_date => value_date)
  end

  def book
    booking = build_booking
    self.state = 'booked'

    return booking
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
      when 'booked', 'printed': remind_first_time
      when 'reminded':          remind_second_time
      when '2xreminded':        remind_third_time
      when '3xreminded':        encash
    end
  end
  
  def remind_first_time
    self.state = 'reminded'
    self.reminder_due_date = Date.today + REMINDER_PAYMENT_PERIOD[self.state]
    build_reminder_booking
  end
  
  def latest_reminder_value_date
    reminder_booking = bookings.find_by_title(state_noun)
    return reminder_booking.try(:value_date)
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
  
  has_and_belongs_to_many :sessions, :autosave => true
  has_and_belongs_to_many :service_records, :order => 'tariff_type, date DESC, if(ref_code IS NULL, code, ref_code), concat(code,ref_code)'

  # Validation
  validates_presence_of :value_date
#  validates_format_of :value_date, :with => /[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{2,4}/, :message => 'braucht Format dd.mm.yy (z.B. 3.12.1980)'

  validates_presence_of :service_records, :message => 'Keine Leistung eingegeben.'
  validate :valid_service_records?
  
  validates_presence_of :treatment
  validate :valid_treatment?

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
    if treatment.patient
      errors.add_to_base(treatment.patient.errors.full_messages.join('</li><li>')) unless treatment.patient.valid_for_invoice?
    else
      errors.add_to_base("Patient fehlt") unless treatment.patient
    end

    return errors.empty?
  end
  
  # Accounting
  has_many :bookings, :class_name => 'Booking', :as => 'reference', :order => 'value_date', :dependent => :destroy
  def due_amount(value_date = nil)
    if value_date
      included_bookings = bookings.find(:all, :conditions => ["value_date <= ?", value_date])
    else
      included_bookings = bookings
    end
    included_bookings.to_a.sum{|b| b.accounted_amount(Invoice::DEBIT_ACCOUNT)}
  end
  
  # HasAccount compatibility
  alias customer patient
  alias balance due_amount

  # Batch Jobs
  has_and_belongs_to_many :invoice_batch_jobs

  # Callback hook
  def booking_saved(booking)
    # Don't touch state if canceled of reactivated
    return if self.state == 'canceled' or self.state == 'reactivated'

    # Mark as paid unless canceled or reactivated
    if self.due_amount <= 0.0
      update_attribute(:state, 'paid')
    elsif !self.reminded? and (self.due_amount > 0.0)
      update_attribute(:state, 'booked')
    end
  end
  
  public
  
  # Standard methods
  def to_s(format = :default)
    case format
    when :short
      "##{id}: #{I18n.l(value_date) if value_date}"
    else
      "#{patient.name}, Rechnung ##{id} #{I18n.l(value_date)} über #{sprintf('%0.2f', amount)} CHF"
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

  def referrer
    tiers.referrer
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

    args.merge!(:include => {:tiers => {:patient => {:vcards => :addresses}}}, :conditions => ["(#{patient_condition}) OR (#{invoice_condition})", query_params], :order => 'vcards.family_name, vcards.given_name')
    find(:all, args)
  end
  
  # Calculated fields
  def amount_mt(tariff_type = nil, options = {})
    service_records.by_tariff_type(tariff_type).to_a.sum(&:amount_mt)
  end
  
  def amount_tt(tariff_type = nil, options = {})
    service_records.by_tariff_type(tariff_type).to_a.sum(&:amount_tt)
  end
  
  # Returns rounded total amount
  #
  # The total is rounded according to currency rounding rules.
  #
  # tariff_type::
  #   Only use service_records with these types. Can be an array
  def amount(tariff_type = nil, options = {})
    value = service_records.by_tariff_type(tariff_type).to_a.sum(&:amount)

    value.currency_round
  end

  def obligation_amount
    service_records.obligate.to_a.sum(&:amount)
  end

  def tax_points_mt(tariff_type = nil, options = {})
    service_records.by_tariff_type(tariff_type).to_a.sum(&:tax_points_mt)
  end

  def tax_points_tt(tariff_type = nil, options = {})
    service_records.by_tariff_type(tariff_type).to_a.sum(&:tax_points_tt)
  end

  def tax_points(tariff_type = nil, options = {})
    service_records.by_tariff_type(tariff_type).to_a.sum(&:tax_points)
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
    esr9_format(esr9_add_validation_digit(esr_number(bank_account.esr_id, patient.id)))
  end

  private

  # ESR helpers
  def esr_number(esr_id, patient_id)
    esr_id + sprintf('%013i', patient_id).delete(' ') + sprintf('%07i', id).delete(' ')
  end

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

    id_string = esr_number(esr_id, patient.id)

    biller_string = esr9_format_account_id(biller_id)
    return "#{esr9_add_validation_digit(amount_string)}>#{esr9_add_validation_digit(id_string)}+ #{biller_string}>"
  end
  
  # PDF/Print
  def insurance_recipe_to_pdf
    prawn_options = { :page_size => 'A4', :top_margin => 1.5.cm, :left_margin => 1.cm, :right_margin => 1.cm, :bottom_margin => 1.8.cm }
    pdf = Prawn::InsuranceRecipe.new(prawn_options)
    
    return pdf.to_pdf(self)
  end

  def print_insurance_recipe(printer)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.puts(insurance_recipe_to_pdf)
    file.close

    # Try twice
    begin
      paper_copy = Cups::PrintJob.new(file.path, printer)
    rescue
      paper_copy = Cups::PrintJob.new(file.path, printer)
    end
    paper_copy.print
  end

  def patient_letter_to_pdf
    pdf = Prawn::PatientLetter.new
    
    return pdf.to_pdf(self)
  end

  def print_patient_letter(printer)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.puts(patient_letter_to_pdf)
    file.close

    # Try twice
    begin
      paper_copy = Cups::PrintJob.new(file.path, printer)
    rescue
      paper_copy = Cups::PrintJob.new(file.path, printer)
    end
    paper_copy.print
  end

  def print(insurance_recipe_printer, patient_letter_printer)
    print_patient_letter(patient_letter_printer)
    print_insurance_recipe(insurance_recipe_printer)
  end

  # Reminders
  def reminder_letter_to_pdf
    prawn_options = { :page_size => 'A4', :top_margin => 35, :left_margin => 12, :right_margin => 12, :bottom_margin => 23 }
    pdf = Prawn::ReminderLetter.new(prawn_options)

    return pdf.to_pdf(self)
  end

  def print_reminder(printer)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.puts(reminder_letter_to_pdf)
    file.close

    # Try twice
    begin
      paper_copy = Cups::PrintJob.new(file.path, printer)
    rescue
      paper_copy = Cups::PrintJob.new(file.path, printer)
    end
    paper_copy.print
  end
end
