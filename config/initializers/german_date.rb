# Use german, human readable date and time formats.
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default] = '%d.%m.%Y'
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:default] = '%H:%M'

# Drop US formats to remove ambiguity with d/m/yy
ValidatesTimeliness::Formats.remove_us_formats
