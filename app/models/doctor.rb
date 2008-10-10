class Doctor < ActiveRecord::Base
  belongs_to :praxis, :class_name => 'Vcards::Vcard', :foreign_key => 'praxis_vcard'
  belongs_to :private, :class_name => 'Vcards::Vcard', :foreign_key => 'private_vcard'

  belongs_to :billing_doctor, :class_name => 'Doctor'
  belongs_to :account, :class_name => 'Accounting::Account'

  has_many :mailings
  has_many :patients

  has_and_belongs_to_many :offices

  # Proxy accessors
  def name
    praxis.full_name || ""
  end

  def colleagues
    offices.map{|o| o.doctors}.flatten.uniq
  end

  def password=(value)
    write_attribute(:password, Digest::SHA256.hexdigest(value))
  end

  # TODO:
  # This is kind of a primary office providing printers etc.
  # But it undermines the assumption that a doctor may belong/
  # own more than one office.
  def office
    offices.first
  end

  # ZSR sanitation
  def zsr=(value)
    write_attribute(:zsr, value.delete(' .'))
  end
end
