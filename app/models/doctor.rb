class Doctor < ActiveRecord::Base
  belongs_to :praxis, :class_name => 'Vcards::Vcard', :foreign_key => 'praxis_vcard'
  belongs_to :private, :class_name => 'Vcards::Vcard', :foreign_key => 'private_vcard'

  belongs_to :billing_doctor, :class_name => 'Doctor'

  has_many :mailings

  # Proxy accessors
  def name
    praxis.full_name || ""
  end
end
