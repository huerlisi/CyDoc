# -*- encoding : utf-8 -*-
class AddTreatmentToSessions < ActiveRecord::Migration
  def self.up
    add_column :sessions, :treatment_id, :integer
    Session.all.map{|s|
      if s.invoice
        s.treatment = s.invoice.treatment
        s.save
      else
        puts "No invoice/treatment for #{s.to_s}"
      end
    }
  end

  def self.down
    remove_column :sessions, :treatment_id
  end
end
