# -*- encoding : utf-8 -*-
class ChangeOpenStateToNewForRecalls < ActiveRecord::Migration
  def self.up
    Recall.update_all("state = 'new'", "state = 'open'")
  end

  def self.down
  end
end
