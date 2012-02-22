class EsrRecord < ActiveRecord::Base
  belongs_to :esr_file
  
  belongs_to :booking, :dependent => :destroy
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
    transitions :from => :underpaid, :to => :resolved
  end

  aasm_event :book_extra_earning do
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
    if invoice.state == 'paid'
      # already paid
      if invoice.amount == self.amount.currency_round
        # paid twice
        self.remarks += ", doppelt bezahlt"
      else
        self.remarks += ", bereits bezahlt"
      end
    elsif !(invoice.active)
      # canceled invoice
      self.remarks += ", wurde bereits #{invoice.state_adverb}"
    elsif invoice.amount == self.amount.currency_round
      # TODO much too open condition (issue #804)
      # reminder fee not paid
      self.remarks += ", Mahnspesen nicht bezahlt"
    else
      # bad amount
      self.remarks += ", falscher Betrag"
    end
  end

  def update_state
    if self.invoice.nil?
      self.state = 'missing'
      return
    end

    balance = self.invoice.balance.currency_round
    if balance == 0
      self.state = 'paid'
    elsif balance > 0
      self.state = 'underpaid'
    elsif balance < 0
      self.state = 'overpaid'
    end
  end

  def self.update_invalid_states
    self.invalid.find_each do |e|
      e.update_state
      e.save
    end
  end

  # Invoices
  before_create :assign_invoice, :create_esr_booking
  
  private
  def assign_invoice
    # Prepare remarks to not be null
    self.remarks ||= ''

    self.remarks += "Referenz #{reference}"

    if Invoice.exists?(invoice_id)
      self.invoice_id = invoice_id
      update_remarks
      update_state

    elsif imported_invoice = Invoice.find(:first, :conditions => ["imported_esr_reference LIKE concat(?, '%')", reference])
      self.invoice = imported_invoice
      update_remarks
      update_state

    else
      self.remarks += ", Rechnung ##{invoice_id} nicht gefunden"
      self.state = "missing"
    end
  end
  
  def vesr_account
    BankAccount.find_by_esr_id(client_id)
  end

  def create_esr_booking
    if invoice
      esr_booking = invoice.bookings.build
    else
      esr_booking = Booking.new
    end
    
    esr_booking.update_attributes(
      :amount         => amount,
      :credit_account => vesr_account,
      :debit_account  => Invoice::DEBIT_ACCOUNT,
      :value_date     => value_date,
      :title          => "VESR Zahlung",
      :comments       => remarks)
    
    esr_booking.save
 
    self.booking = esr_booking
    
    return esr_booking
  end

public
  def create_extra_earning_booking(comments = nil)
    Booking.create(:title => "Ausserordentlicher Ertrag",
                   :comments => comments || "Zahlung kann keiner Rechnung zugewiesen werden",
                   :amount => self.amount,
                   :debit_account  => Invoice::EXTRA_EARNINGS_ACCOUNT,
                   :credit_account => Invoice::DEBIT_ACCOUNT,
                   :value_date => Date.today)
  end
end
