class VatClass < ActiveRecord::Base
  named_scope :valid, :conditions => ['valid_from <= ?', Date.today]
  named_scope :current, :conditions => ['valid_from <= ?', Date.today], :order => 'valid_from DESC', :limit => 1

  def code_name
    case code
      when 'reduced': "Reduziert"
      when 'full': "Normal"
      when 'excluded': "Ausgenommen"
    end
  end
end
