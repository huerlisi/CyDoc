# -*- encoding : utf-8 -*-
class BuildAppointmentsForRecalls < ActiveRecord::Migration
  def self.up
    for recall in Recall.find(:all, :conditions => {:appointment_id => nil})
      recall.build_appointment(:state => 'proposed', :patient => recall.patient, :date => recall.due_date)
      recall.save
    end
  end

  def self.down
  end
end
