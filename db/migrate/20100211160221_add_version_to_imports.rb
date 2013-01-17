# -*- encoding : utf-8 -*-
class AddVersionToImports < ActiveRecord::Migration
  def self.up
    add_column :imports, :version, :string
  end

  def self.down
    remove_column :imports, :version
  end
end
