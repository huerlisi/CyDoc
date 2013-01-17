# -*- encoding : utf-8 -*-
module UserHelper
  def user_object_collection
    [
      [t_model(Doctor), Doctor.all.map{|u| [u.to_s, "Doctor:#{u.id}"]}].compact,
      [t_model(Employee), Employee.all.map{|u| [u.to_s, "Person:#{u.id}"]}].compact
    ].compact
  end
end

