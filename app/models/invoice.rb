class Invoice < ActiveRecord::Base
  belongs_to :tiers
  belongs_to :law

  has_and_belongs_to_many :treatment
  has_and_belongs_to_many :record_tarmeds
end
