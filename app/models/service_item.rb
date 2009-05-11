class ServiceItem < ActiveRecord::Base
  belongs_to :tariff_item_group
  belongs_to :tariff_item

  def to_s
    "#{quantity} x #{tariff_item.to_s}"
  end

  def create_service_record(patient, provider, responsible = nil)
    # Create service_record based on associated tariff_item
    service_record = tariff_item.create_service_record(patient, provider, responsible)

    # Fill in instance attributes
    service_record.ref_code = ref_code if ref_code
    service_record.quantity = quantity if quantity
    
    return service_record
  end
end
