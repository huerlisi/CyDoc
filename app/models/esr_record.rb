class EsrRecord < ActiveRecord::Base
  belongs_to :esr_file
  
  belongs_to :booking, :class_name => 'Accounting::Booking'
  belongs_to :invoice

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

  def parse(line)
#    self.recipe_type       = line[0, 1]
    self.client_nr         = line[3..11]
    self.reference         = line[12..38]
    # TODO: very bad rounding, use some fixnum/currency type
    self.amount            = line[39..48].to_f / 100
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
  before_create :assign_invoice
  
  private
  def assign_invoice
    invoice_id = reference[6..-1].to_i
    self.invoice_id = invoice_id if Invoice.exists?(invoice_id)
  end
end
