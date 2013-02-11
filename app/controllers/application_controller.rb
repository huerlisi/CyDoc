# -*- encoding : utf-8 -*-
require 'prawn/measurement_extensions'

class ApplicationController < ActionController::Base
  # Aspects
  protect_from_forgery

  # Authentication
  before_filter :authenticate_user!

  # Set the user locale
  before_filter :set_locale

  def set_locale
    locale = params[:locale] || cookies[:locale]
    I18n.locale = locale.to_s
    cookies[:locale] = locale unless (cookies[:locale] && cookies[:locale] == locale.to_s)
  end

  def current_doctor
    current_tenant
  end

  # Tenancy
  def current_tenant
    current_user.tenant
  end

  private

  # Show single search match
  def redirect_if_match(collection)
    if collection.size == 1
      respond_to do |format|
        format.html {
          redirect_to collection.first
        }
        format.js {
          render :update do |page|
            page.redirect_to collection.first
          end
        }
      end

      return true
    else
      return false
    end
  end

  private
  # TODO: Nice hack to add REGEXP support for SQLite, but application controller is bad place...
  def regexp_for_sqlite
    if ActiveRecord::Base.connection.adapter_name.eql?("SQLite")
      db = ActiveRecord::Base.connection.instance_variable_get(:@connection)
      db.create_function("regexp", 2) do |func, expr, value|
        begin
          if value.to_s && value.to_s.match(Regexp.new(expr.to_s))
            func.set_result 1
          else
           func.set_result 0
          end
        rescue => e
          puts "error: #{e}"
        end
      end
    end
  end
end

module ActionView
  module Helpers
    module FormHelper
      def date_field(object_name, method, options = {})
        instance_tag = InstanceTag.new(object_name, method, self, options.delete(:object))

        # Let InstanceTag do the object/attribute lookup for us
        value = instance_tag.value(instance_tag.object)

        # value is empty when re-showing field after error, use params
        options["value"] =  value.to_s(:text_field) if value.is_a?(Date)
        options["value"] ||= params[object_name][method] if params[object_name]

        instance_tag.to_input_field_tag("text", options)
      end

      def time_field(object_name, method, options = {})
        instance_tag = InstanceTag.new(object_name, method, self, options.delete(:object))

        # Let InstanceTag do the object/attribute lookup for us
        value = instance_tag.value(instance_tag.object)

        # value is empty when re-showing field after error, use params
        options["value"] =  value.to_s(:text_field) if (value.is_a?(Time) or value.is_a?(DateTime))
        options["value"] ||= params[object_name][method] if params[object_name]

        instance_tag.to_input_field_tag("text", options)
      end
    end

    class FormBuilder
      def date_field(method, options = {})
        @template.date_field(@object_name, method, objectify_options(options))
      end

      def time_field(method, options = {})
        @template.time_field(@object_name, method, objectify_options(options))
      end
    end
  end
end

# Monkay patch formtastic
class Formtastic::SemanticFormBuilder
  # Outputs a label and standard Rails text field inside the wrapper.
  def date_field_input(method, options)
    basic_input_helper(:date_field, :string, method, options)
  end

  def time_field_input(method, options)
    basic_input_helper(:time_field, :string, method, options)
  end

  # Add :validates_date to requiring validations
  def method_required?(attribute)
    if @object && @object.class.respond_to?(:reflect_on_validations_for)
      attribute_sym = attribute.to_s.sub(/_id$/, '').to_sym

      @object.class.reflect_on_validations_for(attribute_sym).any? do |validation|
        [:validates_presence_of, :validates_date, :validates_time].include?(validation.macro) &&
        validation.name == attribute_sym && !(validation.options.present? && (validation.options[:allow_nil] || validation.options[:allow_blank])) &&
        (validation.options.present? ? options_require_validation?(validation.options) : true)
      end
    else
      false
    end
  end
end

# Monkey patching Date class
class Date
  # Date helpers
  def self.parse_europe(value, base = :future)
    return value if value.is_a?(Date)
    return value.to_date if value.is_a?(Time)

    return nil if value.blank?

    if value.is_a?(String)
      if value.match /.*-.*-.*/
        return Date.parse(value)
      end
      day, month, year = value.split('.').map {|s| s.to_i}
      month ||= Date.today.month
      year ||= Date.today.year
      year = expand_year(year, base)

      return Date.new(year, month, day)
    else
      return value
    end
  end

  def self.date_only_year?(value)
    value.is_a?(String) and value.strip.match /^\d{2,4}$/
  end

  def self.expand_year(value, base = :future)
    value = value.to_i
    return value unless value < 100

    century = Date.today.year / 100
    year = Date.today.year % 100

    case base
    when :future
      offset = value < year ? 100 : 0
    when :past
      offset = value <= year ? 0 : -100
    end

    return 100 * century + value + offset
  end
end

class ActiveRecord::Base
   def becomes(klass)
     became = klass.new
     became.instance_variable_set("@attributes", @attributes)
     became.instance_variable_set("@attributes_cache", @attributes_cache)
     became.instance_variable_set("@errors", @errors)
     became.instance_variable_set("@new_record", new_record?)
     became.instance_variable_set("@destroyed", destroyed?)
     became
   end
end
