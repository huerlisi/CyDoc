# -*- encoding : utf-8 -*-
class CreateServiceRecordsSessions < ActiveRecord::Migration
  def self.up
    create_table :service_records_sessions, :id => false do |t|
      t.integer :service_record_id
      t.integer :session_id
    end
  end

  def self.down
    drop_table :service_records_sessions
  end
end
