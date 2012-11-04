class ComboboxInput < SimpleForm::Inputs::CollectionSelectInput
  include ActionView::Helpers::UrlHelper
  include BootstrapHelper

  def link_fragment
    reference = nil
    url_method = nil
    if reflection
      reference = object.send(reflection.name)
      url_method = "new_#{reflection.name}_#{object.class.model_name.underscore.pluralize}_url"
    end

    if reference
      template.content_tag('span', template.link_to(boot_icon("eye-open"), object.send(reflection.name)), :class => 'combobox-link')
    else
      if url_method && template.respond_to?(url_method)
        template.content_tag('span', template.link_to(boot_icon("plus"), template.send(url_method), :remote => true), :class => "combobox-link new_#{reflection.name}")
      end
    end
  end

  def input
    super + link_fragment
  end
end
