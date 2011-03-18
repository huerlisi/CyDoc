require 'routing_filter/filter'

module RoutingFilter
  class Locale < Filter
    def around_recognize(path, env, &block)
      locale = nil
      path.sub! %r(^/([a-zA-Z]{2}|[a-zA-Z]{2}-[a-zA-Z]{2})(?=/|$)) do locale = $1; '' end

      yield.tap do |params|
        params[:locale] = locale || I18n.default_locale
      end
    end
    
    def around_generate(*args, &block)
      locale = args.extract_options!.delete(:locale) || I18n.default_locale

      yield.tap do |result|
        if locale != I18n.default_locale
          result.sub!(%r(^(http.?://[^/]*)?(.*))){ "#{$1}/#{locale}#{$2}" }
        end
      end
    end
  end
end
