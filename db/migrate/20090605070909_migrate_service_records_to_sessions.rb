# -*- encoding : utf-8 -*-
require 'session'

class Session
  def self.build_from_invoice(invoice)
    session = self.new
    
    session.patient = invoice.patient
    session.duration_from = invoice.treatment.date_begin
    session.duration_to = invoice.treatment.date_end
    session.diagnoses = invoice.treatment.diagnoses
    session.service_records = invoice.service_records
    
    session.invoice = invoice
    session.state = 'closed'
    
    return session
  end

  def self.create_for_all_service_records
    patients = ServiceRecord.all.map{|s| s.patient}.compact.uniq
    
    for patient in patients
      puts "Sessions for patient #{patient.to_s}"
      
      dates = patient.service_records.map{|s| s.date}.uniq
      for date in dates
        puts "  #{date.strftime('%d.%m.%Y')}"
        session = patient.sessions.build(
          :duration_from => date,
          :duration_to => date,
          :state => 'open'
        )
        session.service_records = patient.service_records.find(:all, :conditions => {:date => date})
        session.save
      end
    end
    
    return nil
  end

  def self.map_from_invoices
    for invoice in Invoice.all :order => 'updated_at DESC'
      puts "Invoice #{invoice.to_s}"
      for record in invoice.service_records
        for session in record.sessions
          if session.invoice.nil?
            puts "  assigned session #{session.to_s}"
            session.invoice = invoice
            session.diagnoses = invoice.treatment.diagnoses
            session.state = 'closed'
            session.save
          end
        end
      end
    end
    
    return nil
  end
end

class MigrateServiceRecordsToSessions < ActiveRecord::Migration
  def self.up
    ServiceRecord.update_all "date = DATE(date)"
    
    Session.create_for_all_service_records
    Session.map_from_invoices
  end

  def self.down
  end
end
