# -*- encoding : utf-8 -*-
class TariffItemGroup < TariffItem
  has_many :service_items, :order => 'position'
  accepts_nested_attributes_for :service_items
  attr_accessible :service_items_attributes

  def tariff_type
    "Blockleistung"
  end

  def to_s(format = :default)
    group_s = super
    if format == :long
      group_s + " (#{service_items.count} pos.):\n" + service_items.map{|item| "      " + item.to_s}.join("\n")
    end

    group_s
  end

  def clone
    new_clone = super

    new_clone.service_items = service_items.map{|s| s.clone}

    return new_clone
  end

  # Accumulated amounts
  def amount_mt
    service_items.map{|s| s.amount_mt}.sum
  end

  def amount_tt
    service_items.map{|s| s.amount_tt}.sum
  end

  def amount
    service_items.map{|s| s.amount}.sum
  end

  def create_service_record(session)
    service_items.collect{|item|
      item.create_service_record(session)
    }
  end
end
