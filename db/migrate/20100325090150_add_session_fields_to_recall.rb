# -*- encoding : utf-8 -*-
class AddSessionFieldsToRecall < ActiveRecord::Migration
  def self.up
    add_column :recalls, :session_id, :integer
  end

  def self.down
    remove_column :recalls, :session_id
  end
end
