# encoding: UTF-8
class EsrRecord < ActiveRecord::Base
  belongs_to :esr_file

  belongs_to :booking, :dependent => :destroy, :autosave => true
  belongs_to :invoice

  # State Machine
  include AASM
  aasm_column :state
  validates_presence_of :state

  aasm_initial_state :ready
  aasm_state :ready
  aasm_state :paid
  aasm_state :missing
  aasm_state :overpaid
  aasm_state :underpaid
  aasm_state :resolved

  aasm_event :write_off do
    transitions :from => :underpaid, :to => :resolved
  end

  aasm_event :resolve do
    transitions :from => [:overpaid, :missing, :underpaid], :to => :resolved
  end

  aasm_event :book_extra_earning do
    transitions :from => [:overpaid, :missing], :to => :resolved
  end

  aasm_event :book_payback do
    transitions :from => [:overpaid, :missing], :to => :resolved
  end

  named_scope :invalid, :conditions => {:state => ['overpaid', 'underpaid', 'resolved']}
  named_scope :unsolved, :conditions => {:state => ['overpaid', 'underpaid', 'missing']}
  named_scope :valid, :conditions => {:state => 'paid'}

  private
  def parse_date(value)
    year  = value[0..1].to_i + 2000
    month = value[2..3].to_i
    day   = value[4..5].to_i

    return Date.new(year, month, day)
  end

  def payment_date=(value)
    write_attribute(:payment_date, parse_date(value))
  end

  def transaction_date=(value)
    write_attribute(:transaction_date, parse_date(value))
  end

  def value_date=(value)
    write_attribute(:value_date, parse_date(value))
  end

  def reference=(value)
    write_attribute(:reference, value[0..-2])
  end

  public
  def to_s
    "CHF #{amount} for client #{client_id} on #{value_date}, reference #{reference}"
  end

  def client_id
    reference[0..5]
  end

  def invoice_id
    reference[19..-1].to_i
  end

  def patient_id
    reference[6..18].to_i
  end

  def parse(line)
#    self.recipe_type       = line[0, 1]
    self.bank_pc_id        = line[3..11]
    self.reference         = line[12..38]
    self.amount            = BigDecimal.new(line[39..48]) / 100
    self.payment_reference = line[49..58]
    self.payment_date      = line[59..64]
    self.transaction_date  = line[65..70]
    self.value_date        = line[71..76]
    self.microfilm_nr      = line[77..85]
    self.reject_code       = line[86, 1]
    self.reserved          = line[87,95]
    self.payment_tax       = line[96..99]

    self
  end

  def update_remarks
    # Invoice not found
    if self.state == 'missing'
      self.remarks += ", Rechnung ##{invoice_id} nicht gefunden"
      return
    end

    # Remark if invoice should not get payment according to state
    if !(invoice.active)
      self.remarks += ", wurde bereits #{invoice.state_adverb}"
      return
    end

    # Perfect payment
    return if invoice.balance == 0

    # Paid more than once
    if (self.state == 'overpaid') and (invoice.amount == self.amount)
      self.remarks += ", mehrfach bezahlt"
      return
    end

    # Not fully paid
    if (self.state == 'underpaid')
      self.remarks += ", Teilzahlung"
      return
    end

    # Simply mark bad amount otherwise
    self.remarks += ", falscher Betrag"
  end

  def update_state
    if self.invoice.nil?
      self.state = 'missing'
      return
    end

    balance = self.invoice.balance
    if balance == 0
      self.state = 'paid'
    elsif balance > 0
      self.state = 'underpaid'
    elsif balance < 0
      self.state = 'overpaid'
    end
  end

  def self.update_unsolved_states
    self.unsolved.find_each do |e|
      e.update_state
      e.save
    end
  end

  # Invoices
  before_create :assign_invoice, :create_esr_booking, :update_state, :update_remarks, :update_invoice_state

  private
  def assign_invoice
    # Prepare remarks to not be null
    self.remarks ||= ''

    self.remarks += "Referenz #{reference}"

    if Invoice.exists?(invoice_id)
      self.invoice_id = invoice_id
    elsif Invoice.column_names.include?(:imported_esr_reference) && imported_invoice = Invoice.find(:first, :conditions => ["imported_esr_reference LIKE concat(?, '%')", reference])
      self.invoice = imported_invoice
    end
  end

  def vesr_account
    BankAccount.find_by_esr_id(client_id)
  end

  def create_esr_booking
    if invoice
      esr_booking = invoice.bookings.build
      debit_account = invoice.balance_account
    else
      esr_booking = Booking.new
      debit_account = Invoice.direct_account
    end

    esr_booking.update_attributes(
      :amount         => amount,
      :credit_account => vesr_account,
      :debit_account  => debit_account,
      :value_date     => value_date,
      :title          => "VESR Zahlung",
      :comments       => remarks
    )

    esr_booking.save

    self.booking = esr_booking

    return esr_booking
  end

  def update_invoice_state
    if invoice
      # Only call if callback is available
      return unless invoice.respond_to?(:calculate_state)

      invoice.calculate_state
      invoice.save
    end
  end

public
  def create_payback_booking
    if invoice
      booking = invoice.bookings.build

      credit_account = invoice.balance_account
      amount = -invoice.due_amount
    else
      booking = Booking.new

      credit_account ||= Account.find_by_code(Invoice.settings['invoices.balance_account_code'])
      amount = self.amount
    end

    booking.attributes = {
      :title => "Rückerstattung",
      :comments => "Zuviel bezahlt",
      :amount => amount,
      :credit_account => credit_account,
      :debit_account => vesr_account,
      :value_date => Date.today
    }

    booking.save
  end

  def create_write_off_booking
    invoice.write_off("Korrektur nach VESR Zahlung").save
  end

  def create_extra_earning_booking(comments = nil)
    if invoice
      invoice.book_extra_earning("Korrektur nach VESR Zahlung").save
    else
      Booking.new(:title => "Ausserordentlicher Ertrag",
                     :comments => comments || "Zahlung kann keiner Rechnung zugewiesen werden",
                     :amount => self.amount,
                     :debit_account  => Account.find_by_code(Invoice.settings['invoices.extra_earnings_account_code']),
                     :credit_account => Account.find_by_code(Invoice.settings['invoices.balance_account_code']),
                     :value_date => Date.today).save
    end
  end
end
