class EsrRecord < ActiveRecord::Base
  belongs_to :esr_file
  
  belongs_to :booking, :dependent => :destroy
  belongs_to :invoice
  
  named_scope :valid, :conditions => "state = 'valid'"
  named_scope :missing, :conditions => "state = 'missing'"
  named_scope :bad, :conditions => "state = 'bad'"
  named_scope :invalid, :conditions => "state != 'valid'"
  
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

  # Invoices
  before_create :assign_invoice, :create_esr_booking
  
  private
  def evaluate_bad
    if invoice.state == 'paid'
      # already paid
      if invoice.amount.currency_round == self.amount.currency_round
        # paid twice
        self.remarks += ", doppelt bezahlt"
      else
        self.remarks += ", bereits bezahlt"
      end
    elsif !(invoice.active)
      # canceled invoice
      self.remarks += ", wurde #{invoice.state_adverb}"
    elsif invoice.amount.currency_round == self.amount.currency_round
      # TODO much too open condition (issue #804)
      # reminder fee not paid
      self.remarks += ", Mahnspesen nicht bezahlt"
    else
      # bad amount
      self.remarks += ", falscher Betrag"
    end
  end
  
  def assign_invoice
    if Invoice.exists?(invoice_id)
      self.invoice_id = invoice_id
      self.remarks += "Referenz #{reference}"
      if invoice.due_amount.currency_round != self.amount.currency_round
        evaluate_bad
        self.state = "bad"
      else
        self.state = "valid"
      end
    elsif imported_invoice = Invoice.find(:first, :conditions => ["imported_esr_reference LIKE concat(?, '%')", reference])
      self.invoice = imported_invoice
      self.remarks += "Referenz #{reference}"
      if invoice.due_amount.currency_round != self.amount.currency_round
        self.remarks += ", falscher Betrag"
        self.state = "bad"
      else
        self.state = "valid"
      end
    else
      self.remarks += "Rechnung ##{invoice_id} nicht gefunden"
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
end
