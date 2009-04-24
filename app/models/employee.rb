class Employee < ActiveRecord::Base
  has_vcards
  
  named_scope :health_care, :conditions => {:role => 'H'}
  named_scope :accident, :conditions => {:role => 'A'}

  # Authentication
  has_one :user, :as => :object

  def to_s
    "#{name} (#{user.login})"
  end
  
  # Proxy accessors
  def name
    if vcard.nil?
      ""
    else
      vcard.full_name || ""
    end
  end
end
