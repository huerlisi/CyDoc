# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
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
    stylesheet += controller.send(:render_to_string, :file => File.join(RAILS_ROOT, 'public', 'stylesheets', "#{name}.css"))
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

 # CRUD helpers
  def icon_edit_link_to(path)
    link_to t_action(:edit), path, :method => :get, :class => 'icon-edit-text', :title => t_action(:edit)
  end

  def icon_delete_link_to(model, path)
    link_to t_action(:delete), path, :remote => true, :method => :delete, :confirm => t_confirm_delete(model), :class => 'icon-delete-text', :title => t_action(:delete)
  end

  # Rails UJS
  def csrf_meta_tag
    if protect_against_forgery?
      out = %(<meta name="csrf-param" content="%s"/>\n)
      out << %(<meta name="csrf-token" content="%s"/>)
      out % [ Rack::Utils.escape_html(request_forgery_protection_token),
              Rack::Utils.escape_html(form_authenticity_token) ]
    end
  end

  def link_to_remote(body, url_options = {}, html_options = {})
    url = url_options.delete(:url)
    url_options['data-remote'] = true
    if confirm = url_options.delete(:confirm)
      url_options['data-confirm'] = confirm
    end
    if method = url_options.delete(:method)
      url_options['data-method'] = method
    end

    link_to body, url, url_options.merge(html_options)
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
