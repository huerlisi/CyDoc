require 'routing_filter/filter'

module RoutingFilter
  class Locale < Filter

    LOCALE = 'de-CH'

    def around_recognize(path, env, &block)
      locale = nil
      path.sub! %r(^/([a-zA-Z]{2})(?=/|$)) do locale = $1; '' end

      yield.tap do |params|
        params[:locale] = locale || LOCALE
      end
    end
    
    def around_generate(*args, &block)
      locale = args.extract_options!.delete(:locale) || LOCALE

      yield.tap do |result|
        if locale != LOCALE
          result.sub!(%r(^(http.?://[^/]*)?(.*))){ "#{$1}/#{locale}#{$2}" }
        end
      end
    end
  end
end