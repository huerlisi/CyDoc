class Session < ActiveRecord::Base
  # State Machine
  include AASM
  aasm_column :state
  
  aasm_initial_state :open
  
  aasm_state :open
  aasm_state :closed
  
  # Associations
  belongs_to :patient
  belongs_to :invoice
  belongs_to :treatment
  has_and_belongs_to_many :diagnoses
  has_and_belongs_to_many :service_records

  validates_presence_of :duration_from
  
  def to_s(format = :default)
    case format
    when :short
      [date, remarks.blank? ? "Konsultation" : remarks].compact.join(': ')
    else
      "#{diagnoses.map{|d| d.to_s}.join(', ')} for #{patient.name} #{duration_from.strftime('%d.%m.%Y')} - #{duration_to.strftime('%d.%m.%Y')}, #{service_records.count} pos: #{state}"
    end
  end
  
  def amount
    service_records.to_a.sum(&:amount).to_f
  end
  
  def date
    duration_from.to_date unless duration_from.nil?
  end
  
  def date=(value)
    write_attribute(:duration_from, Date.parse_europe(value))
  end
  
  def build_service_record(tariff_item)
    # Type information
    service_record = tariff_item.create_service_record

    if service_record.is_a? Array
      service_record.map{|s|
        s.date = date
        s.patient = patient
      }
    else
      service_record.date = date
      service_record.patient = patient
    end

    service_records << service_record
    return service_record
  end
end
