# -*- encoding : utf-8 -*-
class ServiceItem < ActiveRecord::Base
  # Access restrictions
  attr_accessible :quantity, :ref_code

  belongs_to :tariff_item_group
  belongs_to :tariff_item

  def to_s
    "#{quantity} x #{tariff_item.to_s}"
  end

  def amount_mt
    quantity * tariff_item.amount_mt
  end

  def amount_tt
    quantity * tariff_item.amount_tt
  end

  def amount
    quantity * tariff_item.amount
  end

  def code
    tariff_item.code
  end

  def text
    tariff_item.remark
  end

  # TODO: delegate the following to the tariff_item
  def needs_ref_code?
    text.starts_with?('+')
  end

  def valid_ref_code?
    not (needs_ref_code? and read_attribute(:ref_code).nil?)
  end

  def ref_code
    valid_ref_code? ? read_attribute(:ref_code) : "Fehlende Referenz"
  end

  def create_service_record(session)
    # Create service_record based on associated tariff_item
    service_record = tariff_item.create_service_record(session)

    # Fill in instance attributes
    service_record.ref_code = ref_code if ref_code
    service_record.quantity = quantity if quantity

    return service_record
  end
end
