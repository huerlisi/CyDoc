# -*- encoding : utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_doctor
    current_tenant
  end

  # Tenancy
  def current_tenant
    current_user.tenant
  end

  # Tabs
  def tab_container(name, heading, tabs)
    render :partial => 'shared/tabs', :locals => {:name => name, :heading => heading, :tabs => tabs}
  end

  def sub_tab_container(type, tabs)
    render :partial => 'shared/sub_tabs', :locals => {:tabs => tabs, :type => type}
  end

  # PDF
  def render_inline_stylesheet(name)
    stylesheet = "<style type='text/css'>\n"
    stylesheet += controller.send(:render_to_string, :file => File.join(Rails.root, 'public', 'stylesheets', "#{name}.css"))
    stylesheet += "\n</style>\n"

    return stylesheet
  end

  # Patient Forms
  def setup_patient(patient)
    patient.tap do |p|
      if p.vcard.nil?
        v = p.build_vcard
      end
      if p.insurance_policies.empty?
        p.insurance_policies.build(:policy_type => "KVG")
        p.insurance_policies.build(:policy_type => "UVG")
      end
    end
  end

  # Hozr
  def hozr_env
    if Rails.env.development?
      hostname = "hozr-dev"
    else
      hostname = "hozr"
    end
  end

  def hozr_url_for(path)
    "https://#{hozr_env}/" + path
  end

  def link_to_hozr(title, path, options = {})
    link_to title, hozr_url_for(path), options.merge(:target => hozr_env)
  end
end
