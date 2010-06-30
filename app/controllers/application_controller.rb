# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'digest/sha2'
require 'prawn/measurement_extensions'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '3fcb7aa9a24a90ec6fde37b3755a9ed7'

  # Authentication
  # ==============
  include AuthenticatedSystem
  filter_parameter_logging :password, :password_confirmation, :old_password
  before_filter :login_required, :authenticate

  private
  def authenticate
    return if current_user.nil?
    
    # Authenticate doctor login
    doctor = current_user.object
    unless doctor.nil?
      logger.info("  Doctor login: '#{doctor.name}'")

      @current_doctor_ids = doctor.colleagues.map{|c| c.id}.uniq
      Thread.current["doctor_ids"] = @current_doctor_ids

      @current_doctor = doctor
      Thread.current["doctor_id"] = @current_doctor.id

      @printers = doctor.office.printers
      return true
    end

    # Authenticate doctor login
    office = Office.find_by_login(current_user.login)
    unless office.nil?
      logger.info("  Praxis login: '#{office.name}'")

      @current_doctor_ids = office.doctors.map{|c| c.id}.uniq
      Thread.current["doctor_ids"] = @current_doctor_ids

      @current_doctor = office
      Thread.current["doctor_id"] = @current_doctor.id
      return true
    end
  end

  # PDF generation
  # ==============
  def render_to_pdf(options = {})
    logger.info("Generate PDF with media '#{options[:media]}'")
    html2ps_options = "--media #{options[:media]}" unless options[:media].blank?
    
    logger.info("html2ps.php #{html2ps_options}")
    logger.info("Started PDF generation #{Time.now.strftime('%H:%M:%S')}")
    generator = IO.popen("html2ps.php #{html2ps_options}", "w+")
    generator.puts render_to_string(options)
    generator.close_write

    data = generator.read
    generator.close
    logger.info("Finished PDF generation #{Time.now.strftime('%H:%M:%S')}")
    
    return data
  end

  def render_pdf(options = {})
    options.merge!(:template => "#{controller_name}/#{action_name}.html.erb", :layout => 'simple')
    send_data(render_to_pdf(options))
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
      @@all_fields_required_by_default
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
    when :future:
      offset = value < year ? 100 : 0
    when :past:
      offset = value <= year ? 0 : -100
    end
    
    return 100 * century + value + offset
  end
end

module Print
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def print_action_for(method, options = {})
      define_method("print_#{method}") do
        self.send("#{method}")
        cups_host = options[:cups_host] || @printers[:cups_host]
        tray = options[:tray].to_sym || :plain
        device = options[:device] || @printers[:trays][tray]
        media = options[:media] || 'A4'

        # You probably need the pdftops filter from xpdf, not poppler on the cups host
        # In my setup it generated an empty page otherwise
        pdf_string = render_to_pdf(:template => "#{controller_name}/#{method}.html.erb", :layout => 'simple', :media => media)

        logger.info("lp -h #{cups_host} -d #{device}")
        generator = IO.popen("lp -h #{cups_host} -d #{device}", "w+")

        logger.info("Started printing #{Time.now.strftime('%H:%M:%S')}")
        generator.puts pdf_string
        logger.info("Finished printing #{Time.now.strftime('%H:%M:%S')}")
        generator.close_write

        # Just read to not create zombie processes... TODO: fix
        data = generator.read
        generator.close

        respond_to do |format|
          format.html {}
#          format.js {
#            render :update do |page|
#              page.select('.icon-spinner') do |spinner|
#                spinner.toggleClassName('icon-spinner')
#              end
#            end
#          }
        end
      end
    end
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

ActionController::Base.send :include, Print
