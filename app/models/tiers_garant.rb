class TiersGarant < Tiers
  belongs_to :guarantor, :class_name => 'Patient'
end
