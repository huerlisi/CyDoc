# -*- encoding : utf-8 -*-
class DrugPrice < ActiveRecord::Base
  # Access Restrictions
  attr_accessible :price_type, :valid_from

  # Associations
  belongs_to :drug_article

  # Scopes
  scope :valid, :conditions => ['valid_from <= ?', Date.today]
  scope :current, :conditions => ['valid_from <= ?', Date.today], :order => 'valid_from DESC', :limit => 1

  scope :public, :conditions => {:price_type => 'PPUB' }
  scope :doctor, :conditions => {:price_type => 'PDOC' }
  scope :wholesale, :conditions => {:price_type => ['PDOC', 'PEXF', 'PPHA']}

  def to_s
    "#{price_type} (since #{valid_from}): CHF #{sprintf('%0.2f', price)}"
  end
end
