# -*- encoding : utf-8 -*-
class ChargeSessionsIfTreatmentHasOneActiveInvoice < ActiveRecord::Migration
  def self.up
    for t in Treatment.all
      next if t.invoices.active.count != 1
      
      i = t.invoices.active.first
      t.sessions.map{|s| s.invoice = i; s.state = 'charged'; s.save}
    end
  end

  def self.down
  end
end
