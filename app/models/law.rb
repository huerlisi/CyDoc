# -*- encoding : utf-8 -*-
class Law < ActiveRecord::Base
  # Access restrictions
  attr_accessible :code, :insured_id

  validates_presence_of :code

  has_many :invoices

  def name
    code.gsub(/^Law/, '').upcase
  end
end
