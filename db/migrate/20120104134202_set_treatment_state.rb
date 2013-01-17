# -*- encoding : utf-8 -*-
class SetTreatmentState < ActiveRecord::Migration
  def self.up
    # SQL version of Treatment.update_state
    ActiveRecord::Base.connection.execute("UPDATE treatments SET state = 'new' WHERE id NOT IN (SELECT DISTINCT treatment_id FROM sessions)")
    ActiveRecord::Base.connection.execute("UPDATE treatments SET state = 'open' WHERE id IN (SELECT DISTINCT treatment_id FROM sessions WHERE state = 'open')")
    ActiveRecord::Base.connection.execute("UPDATE treatments SET state = 'charged' WHERE id IN (SELECT DISTINCT treatment_id FROM sessions) AND id NOT IN (SELECT DISTINCT treatment_id FROM sessions WHERE state = 'open')")
  end

  def self.down
  end
end
