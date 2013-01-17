# -*- encoding : utf-8 -*-
class ChangeNewRecallStateToScheduled < ActiveRecord::Migration
  def self.up
    Recall.update_all("state = 'scheduled'", "state = 'new'")
  end

  def self.down
    Recall.update_all("state = 'new'", "state = 'scheduled'")
  end
end
