# Use german, human readable date and time formats.
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default] = lambda {|value| I18n.l(value)}
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:default] = '%H:%M'

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:text_field] = lambda {|value| I18n.l(value)}
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:text_field] = '%H:%M'

# Drop US formats to remove ambiguity with d/m/yy
ValidatesTimeliness::Formats.remove_us_formats
