# encoding: utf-8

class Employee < Person
  # Access restrictions
  attr_accessible :code, :born_on, :workload

  def code
    vcard.nickname || vcard.abbreviated_name
  end

  def code=(value)
    vcard.nickname = value
  end

  def born_on
    date_of_birth
  end

  def born_on=(value)
    date_of_birth = value
  end

  # User
  # =====
  has_one :user, :as => :object, :autosave => true
  attr_accessible :user
end
