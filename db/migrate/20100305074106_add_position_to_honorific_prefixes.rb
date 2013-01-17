# -*- encoding : utf-8 -*-
class AddPositionToHonorificPrefixes < ActiveRecord::Migration
  def self.up
    add_column :honorific_prefixes, :position, :integer
  end

  def self.down
    remove_column :honorific_prefixes, :position
  end
end
