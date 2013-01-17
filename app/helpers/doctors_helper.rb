# -*- encoding : utf-8 -*-
module DoctorsHelper
  def doctors_collection
    Doctor.active.includes(:praxis => :address).order('vcards.family_name, vcards.given_name').collect { |m| [ [ m.family_name, m.given_name ].join(", ") + " (#{m.praxis.try(:locality)})", m.id ] }
  end
end
