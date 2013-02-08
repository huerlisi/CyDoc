# -*- encoding : utf-8 -*-
module DoctorsHelper
  def doctors_collection
    Doctor.active.includes(:vcards => :address).order('vcards.family_name, vcards.given_name').collect { |m| [ m.to_s, m.id ] }
  end
end
