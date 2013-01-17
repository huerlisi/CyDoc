# -*- encoding : utf-8 -*-
class ApplicationController
  private
  def authenticate
    @current_doctor = Doctor.find_by_login('test')
    true
  end
end
