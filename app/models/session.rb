class Session < ActiveRecord::Base
  # Associations
  belongs_to :invoice
  belongs_to :treatment
  has_and_belongs_to_many :diagnoses
  has_and_belongs_to_many :service_records

  # Validations
  validates_presence_of :duration_from
  
  # State Machine
  include AASM
  aasm_column :state
  
  aasm_initial_state :open
  
  aasm_state :open
  aasm_state :charged
  
  aasm_event :charge do
    transitions :to => :charged, :from => :open
  end
  aasm_event :reactivate do
    transitions :to => :open, :from => :charged, :on_transition => :uncharge
  end
  
  private
  def uncharge
    self.invoice = nil
  end
  
  public
  
  def to_s(format = :default)
    case format
    when :short
      [date, remarks.blank? ? "Konsultation" : remarks].compact.join(': ')
    else
      duration = [duration_from, duration_to].compact.map{|d| d.strftime('%d.%m.%Y')}.join(' - ')
      title = remarks.blank? ? "Konsultation" : remarks
      "#{title} (#{state}): #{patient.name} #{duration}, #{service_records.count} positions"
    end
  end
  
  def patient
    treatment.patient
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
