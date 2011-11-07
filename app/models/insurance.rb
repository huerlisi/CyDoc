class Insurance < ActiveRecord::Base
  # String
  def to_s
    "#{[vcard.full_name, vcard.locality].compact.join(', ')} (#{role_code})"
  end

  # Vcard
  has_vcards

  def name
    vcard.full_name
  end

  # Role
  named_scope :health_care, :conditions => {:role => 'H'}
  named_scope :accident, :conditions => {:role => 'A'}

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

  # Search
  def self.clever_find(query)
    return [] if query.nil? or query.empty?
    
    query_params = {}
    query_params[:query] = "%#{query}%"

    vcard_condition = "(vcards.given_name LIKE :query) OR (vcards.family_name LIKE :query) OR (vcards.full_name LIKE :query)"

    find(:all, :include => [:vcard], :conditions => ["#{vcard_condition}", query_params], :order => 'full_name, family_name, given_name')
  end
end
