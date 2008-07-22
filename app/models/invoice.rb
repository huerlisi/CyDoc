class Invoice < ActiveRecord::Base
  belongs_to :tiers
  belongs_to :law
  belongs_to :treatment
end
