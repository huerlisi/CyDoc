class EsrFile < ActiveRecord::Base
  has_attachment :storage => :file_system
  has_many :esr_records, :dependent => :destroy
  
  def to_s(format = :default)
    case format
    when :long
      s = ''
      esr_records.each {|record|
        s += record.to_s + "\n"
      }
      s
    else
      "#{updated_at.strftime('%d.%m.%Y')}: #{file_identifier}"
    end
  end

  after_save :create_records

  private
  def create_records
    File.new(full_filename).each {|line|
      self.esr_records << EsrRecord.new.parse(line) unless line[0..2] == '999'
    }
  end
end
