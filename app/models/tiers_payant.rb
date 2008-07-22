class TiersPayant < Tiers
  belongs_to :guarantor, :class_name => 'Insurance'
end
