class VatClass < ActiveRecord::Base
  # Scopes
  scope :valid, :conditions => ['valid_from <= ?', Date.today], :order => 'valid_from DESC'
  scope :full, :conditions => {:code => 'full'}
  scope :reduced, :conditions => {:code => 'reduced'}
  scope :excluded, :conditions => {:code => 'excluded'}

  def to_s
    "#{'%.1f' % rate}% (#{code_name})"
  end

  # Shortcuts
  def self.full
    valid.full.first
  end

  def self.reduced
    valid.reduced.first
  end

  def self.excluded
    valid.excluded.first
  end

  def code_name
    case code
      when 'full': "Normal"
      when 'reduced': "Reduziert"
      when 'excluded': "Ausgenommen"
    end
  end
end
