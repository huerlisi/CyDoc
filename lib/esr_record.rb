require 'date.rb'

class EsrRecord
  RECIPE_TYPE_ESR=0
  RECIPE_TYPE_ESR_PLUS=1
  RECIPE_TYPE_LSV=2

  PAYMENT_TYPE_ACCOUNT=0
  PAYMENT_TYPE_POST=1

  RECORD_TYPE_CREDIT=2
  RECORD_TYPE_STORNO=5
  RECORD_TYPE_CORRECTION=8

  attr_accessor :recipe_type
  attr_accessor :payment_type
  attr_accessor :record_type
  attr_accessor :client_nr, :reference, :amount
  attr_accessor :payment_reference
  attr_accessor :payment_date, :transaction_date, :value_date
  attr_accessor :microfilm_nr, :reject_code, :reserved, :payment_tax
  
  private
  def parse_date(value)
    year  = value[0..1].to_i + 2000
    month = value[2..3].to_i
    day   = value[4..5].to_i

    return Date.new(year, month, day)
  end

  def payment_date=(value)
    @value_date = parse_date(value)
  end
  
  def transaction_date=(value)
    @transaction_date = parse_date(value)
  end
  
  def value_date=(value)
    @value_date = parse_date(value)
  end
  
  def reference=(value)
    @reference = value[0..-2]
  end
  
  public
  def parse(line)
    self.recipe_type       = line[0, 1]
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
  end

  def initialize(line = nil)
    parse(line) unless line.nil?
  end
  
  def to_s
    "CHF #{amount} for client #{client_nr} on #{value_date}, reference #{reference}"
  end

  # Invoicing
  def invoice_id
    self.reference[6..-1].to_i
  end

  def invoice
    Invoice.find(invoice_id)
  end
end
