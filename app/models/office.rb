# -*- encoding : utf-8 -*-
class Office < ActiveRecord::Base
  # Access restrictions
  attr_accessible :name, :printers

  has_and_belongs_to_many :doctors

  serialize :printers
end
