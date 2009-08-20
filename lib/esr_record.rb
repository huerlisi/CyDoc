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
  attr_accessor :order_reference, :value_date
  
  private
  def value_date=(value)
    year  = value[0..1].to_i + 2000
    month = value[2..3].to_i
    day   = value[4..5].to_i
    @value_date = Date.new(year, month, day)
  end
  
  def reference=(value)
    @reference = value[0..-2]
  end
  
  public
  def parse(line)
    self.recipe_type  = line[0, 1]
    self.client_nr    = line[3..11]
    self.reference    = line[12..38]
    self.amount       = line[39..48].to_f / 100
    self.value_date   = line[71..76]
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
