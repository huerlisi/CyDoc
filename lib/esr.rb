require 'esr_record'

class Esr
  attr_accessor :records

  def parse(file)
    file.each {|line|
               self.records << EsrRecord.new(line) unless line[0..2] == '999'
               }
  end
  
  def initialize(file = nil)
    @records = Array.new
    parse(file) unless file.nil?
  end

  def to_s
    s = ''
    records.each {|record|
                   s += record.to_s + "\n"
                 }
    return s
  end
end
