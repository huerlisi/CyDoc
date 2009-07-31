class ServiceItem < ActiveRecord::Base
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

  def create_service_record
    # Create service_record based on associated tariff_item
    service_record = tariff_item.create_service_record

    # Fill in instance attributes
    service_record.ref_code = ref_code if ref_code
    service_record.quantity = quantity if quantity
    
    return service_record
  end
end
