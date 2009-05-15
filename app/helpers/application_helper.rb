# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Navigation
  def navigation_section(section_title, items = {}, image = "#{title}.png")
    items = items.map {|title, item|
      item = {:controller => item} if item.is_a?(Symbol)
      {:title => title, :url => item}
    }

    render :partial => 'shared/navigation_section', :locals => {:section_title => section_title, :items => items, :image => image}
  end

  # PDF
  def render_inline_stylesheet(name)
    stylesheet = "<style type='text/css'>\n"
    stylesheet += controller.send(:render_to_string, :file => File.join(RAILS_ROOT, 'public', 'stylesheets', "#{name}.css"))
    stylesheet += "\n</style>\n"
    
    return stylesheet
  end
end

