class EsrFile < ActiveRecord::Base
  has_attachment :storage => :file_system
  has_many :esr_records

  def parse
    File.new(full_filename).each {|line|
      self.esr_records << EsrRecord.new.parse(line) unless line[0..2] == '999'
    }
  end
  
  def to_s
    s = ''
    records.each {|record|
                   s += record.to_s + "\n"
                 }
    return s
  end
end
