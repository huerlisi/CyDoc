class Employee < ActiveRecord::Base
  has_vcards
  
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
