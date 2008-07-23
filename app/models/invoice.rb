class Invoice < ActiveRecord::Base
  belongs_to :tiers
  belongs_to :law
  belongs_to :treatment

  has_and_belongs_to_many :record_tarmeds

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
end
