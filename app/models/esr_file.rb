class EsrFile < ActiveRecord::Base
  # File upload
  mount_uploader :file, EsrFileUploader

  # TODO: drop when updating to CarrierWave for Rails > 3
  def file_identifier
    File.basename(file.url)
  end

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
    File.new(file.current_path).each {|line|
      self.esr_records << EsrRecord.new.parse(line) unless line[0..2] == '999'
    }
  end
end
