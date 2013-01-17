# -*- encoding : utf-8 -*-
class AddIndexOnSessionsDurationFrom < ActiveRecord::Migration
  def self.up
    add_index :sessions, :duration_from
  end

  def self.down
  end
end
