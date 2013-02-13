# -*- encoding : utf-8 -*-
class Session < ActiveRecord::Base
  # Access restrictions
  attr_accessible :duration_from, :duration_to, :date, :remarks

  # Associations
  has_and_belongs_to_many :invoices
  belongs_to :treatment, :touch => true
  attr_accessible :treatment

  has_and_belongs_to_many :diagnoses
  has_and_belongs_to_many :service_records, :autosave => true
  accepts_nested_attributes_for :service_records
  attr_accessible :service_records_attributes

  belongs_to :patient

  # Validations
  validates_presence_of :duration_from

  # State Machine
  include AASM
  aasm_column :state

  aasm_initial_state :active

  aasm_state :active
  aasm_state :charged

  aasm_event :charge do
    transitions :to => :charged, :from => :active
  end
  aasm_event :reactivate do
    transitions :to => :active, :from => :charged
  end

  def to_s(format = :default)
    case format
    when :long
      duration = [duration_from, duration_to].compact.map{|d| I18n.l(d)}.join(' - ')
      title = remarks.blank? ? "Konsultation" : remarks
      "#{title} (#{state}): #{patient.name} #{duration}, #{service_records.count} positions"
    else
      [I18n.l(date), remarks.blank? ? "Konsultation" : remarks].compact.join(': ')
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
    new_date = Date.parse_europe(value)

    write_attribute(:duration_from, new_date)

    # Update service_records
    service_records.map{|service_record|
      service_record.date = new_date
    }
  end

  def build_service_record(tariff_item)
    # Type information
    service_record = tariff_item.create_service_record(self)

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

  # Hozr Integration
  has_one :case
end
