# Use german, human readable date and time formats.
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default] = '%d.%m.%Y'
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:default] = '%H:%M'

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:text_field] = lambda {|value| value.strftime('%d.%m.%Y').gsub(/^0/, "").gsub(/\.0/, ".")}
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:text_field] = '%H:%M'

# Drop US formats to remove ambiguity with d/m/yy
ValidatesTimeliness::Formats.remove_us_formats
