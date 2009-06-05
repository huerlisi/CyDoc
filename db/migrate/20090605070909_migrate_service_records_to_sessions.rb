class MigrateServiceRecordsToSessions < ActiveRecord::Migration
  def self.up
    ServiceRecord.update_all "date = DATE(date)"
    
    Session.create_for_all_service_records
    Session.map_from_invoices
  end

  def self.down
  end
end
