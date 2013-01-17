# -*- encoding : utf-8 -*-
class TiersGarant < Tiers
  belongs_to :guarantor, :class_name => 'Patient'

  # TODO: check with spec
  def intermediate
    biller
  end

  def recipient
    patient
  end
end
