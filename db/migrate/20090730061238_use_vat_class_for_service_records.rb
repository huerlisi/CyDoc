# -*- encoding : utf-8 -*-
class UseVatClassForServiceRecords < ActiveRecord::Migration
  def self.up
    add_column :service_records, :vat_class_id, :integer
    
    for service_record in ServiceRecord.all
      service_record.vat_class = VatClass.valid.find_by_rate(service_record.vat_rate)
      service_record.save!
    end
  end

  def self.down
    remove_column :service_records, :vat_class_id
  end
end
