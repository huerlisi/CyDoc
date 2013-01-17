# -*- encoding : utf-8 -*-
class AddIndexOnDunningStopToPatients < ActiveRecord::Migration
  def self.up
    add_index :patients, :dunning_stop
  end

  def self.down
    remove_index :patients, :dunning_stop
  end
end
