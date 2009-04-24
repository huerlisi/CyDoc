class Insurance < ActiveRecord::Base
  has_vcards
  
  named_scope :health_care, :conditions => {:role => 'H'}
  named_scope :accident, :conditions => {:role => 'A'}
  
  def to_s
    [vcard.full_name, vcard.locality].compact.join(', ')
  end

  def name
    vcard.full_name
  end

  # Overrides
  def role_code
    case read_attribute(:role)
      when 'H': "KVG"
      when 'A': "UVG"
    end
  end

  def role
    # TODO: should support multiple formats.
    # TODO: should probably use Law model.
    case read_attribute(:role)
      when 'H': "Krankenversicherung (KVG)"
      when 'A': "Unfallversicherung (UVG)"
    end
  end

  # Group
  def members
    Insurance.find(:all, :conditions => {:group_ean_party => ean_party})
  end
  
  def group
    Insurance.find(:first, :conditions => {:ean_party => group_ean_party})
  end
end
