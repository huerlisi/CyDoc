class EsrRecord < ActiveRecord::Base
  belongs_to :esr_file
  
  belongs_to :booking, :class_name => 'Accounting::Booking'
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
    "CHF #{amount} for client #{client_nr} on #{value_date}, reference #{reference}"
  end

  def client_id
    reference[0..5]
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
    if (invoice.due_amount == 0) and (invoice.amount.currency_round == self.amount.currency_round)
      # paid twice
      self.remarks += ", doppelt bezahlt"
    elsif invoice.amount.currency_round == self.amount.currency_round
      # reminder fee not paied
      self.remarks += ", Mahnspesen nicht bezahlt"
    else
      # bad amount
      self.remarks += ", falscher Betrag"
    end
  end
  
  def assign_invoice
    invoice_id = reference[6..-1].to_i

    if Invoice.exists?(invoice_id)
      self.invoice_id = invoice_id
      self.remarks += "Rechnung ##{invoice_id}"
      if invoice.due_amount.currency_round != self.amount.currency_round
        evaluate_bad
        self.state = "bad"
      else
        self.state = "valid"
      end
    elsif imported_invoice = Invoice.find(:first, :conditions => ["imported_esr_reference LIKE concat(?, '%')", reference])
      self.invoice = imported_invoice
      self.remarks += "Triamun Rechnung ##{invoice.imported_invoice_id}"
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
    Accounting::BankAccount.find_by_esr_id(client_id)
  end

  def create_esr_booking
    if invoice
      esr_booking = invoice.bookings.build
    else
      esr_booking = Accounting::Booking.new
    end
    
    esr_booking.update_attributes(
      :amount         => amount,
      :credit_account => Invoice::DEBIT_ACCOUNT,
      :debit_account  => vesr_account,
      :value_date     => value_date,
      :title          => "VESR Zahlung #{reference}",
      :comments       => remarks )
    
    esr_booking.save
 
    return esr_booking
  end
end
