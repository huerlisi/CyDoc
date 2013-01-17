# -*- encoding : utf-8 -*-
class AddSentAtToRecalls < ActiveRecord::Migration
  def self.up
    add_column :recalls, :sent_at, :datetime
  end

  def self.down
    remove_column :recalls, :sent_at
  end
end
