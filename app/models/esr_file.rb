class EsrFile < ActiveRecord::Base
  has_attachment :storage => :file_system
  has_many :esr_records
  
  after_save :create_records

  def create_records
    File.new(full_filename).each {|line|
      self.esr_records << EsrRecord.new.parse(line) unless line[0..2] == '999'
    }
  end
  
  def to_s
    s = ''
    esr_records.each {|record|
                   s += record.to_s + "\n"
                 }
    return s
  end
end
