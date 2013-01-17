# -*- encoding : utf-8 -*-
class VatClass < ActiveRecord::Base
  # Access restrictions
  attr_accessible :code, :rate, :valid_from

  # Scopes
  scope :valid, :conditions => ['valid_from <= ?', Date.today], :order => 'valid_from DESC'
  scope :full, :conditions => {:code => 'full'}
  scope :reduced, :conditions => {:code => 'reduced'}
  scope :excluded, :conditions => {:code => 'excluded'}

  def to_s
    "#{'%.1f' % rate}% (#{code_name})"
  end

  # Shortcuts
  def code_name
    case code
      when 'full'
        "Normal"
      when 'reduced'
        "Reduziert"
      when 'excluded'
        "Ausgenommen"
    end
  end
end
