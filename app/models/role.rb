# encoding: utf-8

class Role < ActiveRecord::Base
  # Access restrictions
  attr_accessible :name

  # Associations
  has_and_belongs_to_many :users

  validates_presence_of :name

  # Helpers
  def to_s
    I18n.translate(name, :scope => 'cancan.roles')
  end
end
