class Invoice < ActiveRecord::Base
  belongs_to :tiers
  belongs_to :law
  belongs_to :treatment

  has_and_belongs_to_many :record_tarmeds, :after_add => :add_record_tarmed

  # Association callbacks
  def add_record_tarmed(record_tarmed)
    return true if treatment.nil?
    
    treatment.date_begin = record_tarmed.date if (treatment.date_begin.nil? or record_tarmed.date < treatment.date_begin)
    treatment.date_end = record_tarmed.date if (treatment.date_end.nil? or record_tarmed.date > treatment.date_end)
  end
  
  # Convenience methods
  def biller
    tiers.biller
  end

  def provider
    tiers.provider
  end

  def insurance
    tiers.insurance
  end

  def patient
    tiers.patient
  end

  def referrer
    tiers.provider
  end

  def employer
    tiers.employer
  end

  def case_id
    law.case_id
  end

  # Generalization
  def date
    created_at
  end

  def date=(value)
    write_attribute(:created_at, value)
  end
end
