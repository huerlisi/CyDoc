class Patient < ActiveRecord::Base
  belongs_to :insurance
  belongs_to :doctor
  belongs_to :vcard, :class_name => 'Vcards::Vcard', :foreign_key => 'vcard_id'
  belongs_to :billing_vcard, :class_name => 'Vcards::Vcard', :foreign_key => 'billing_vcard_id'
        
  has_many :cases, :order => 'id DESC'

  # Medical history
  has_many :medical_cases, :order => 'duration_from DESC'

  # Proxy accessors
  def name
    vcard.full_name || ""
  end
end
