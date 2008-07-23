class Invoice < ActiveRecord::Base
  belongs_to :tiers
  belongs_to :law
  belongs_to :treatment

  has_and_belongs_to_many :record_tarmeds

  # convenience accessors
  def biller
    tiers.biller
  end

  def provider
    tiers.provider
  end

  def patient
    tiers.patient
  end

  def case_id
    law.case_id
  end
end
