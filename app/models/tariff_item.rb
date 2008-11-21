class TariffItem < ActiveRecord::Base
  has_and_belongs_to_many :tariff_item_groups
end
