# -*- encoding : utf-8 -*-
class AuthorizedController < InheritedResources::Base
  # Authorization
  load_and_authorize_resource

  # Set scope for pagination
  has_scope :page, :default => 1
  has_scope :per

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = t('cancan.access_denied')

    if user_signed_in?
      if request.env["HTTP_REFERER"]
        # Show error on referring page for logged in users
        redirect_to :back
      else
        redirect_to root_path
      end
    else
      # Redirect to login page otherwise
      redirect_to new_user_session_path
    end
  end

  # Redirect to the called path before the login
  def after_sign_in_path_for(resource)
      (session[:"user.return_to"].nil?) ? "/" : session[:"user.return_to"].to_s
  end

  # Responders
  respond_to :html, :js, :json

  # Flash messages
  def interpolation_options
    begin
      { :resource_link => render_to_string(:partial => 'layouts/flash_new').html_safe }
    rescue
      {}
    end
  end

  # Set the user locale
  before_filter :set_locale
  def set_locale
    locale = params[:locale] || cookies[:locale]
    I18n.locale = locale.to_s
    cookies[:locale] = locale unless (cookies[:locale] && cookies[:locale] == locale.to_s)
  end
end
