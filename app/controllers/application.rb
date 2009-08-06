# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'digest/sha2'

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
    generator = IO.popen("html2ps.php #{html2ps_options}", "w+")
    generator.puts render_to_string(options)
    generator.close_write

    data = generator.read
    generator.close
    
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
        text_field object_name, method, options
      end
    end

    class FormBuilder
      def date_field(method, options = {})
        @template.date_field(@object_name, method.to_s + "_formatted", objectify_options(options))
      end
    end
  end
end

class Date
  # Date helpers
  def self.parse_europe(value)
    return nil if value.empty?
    if value.is_a?(String)
      if value.match /.*-.*-.*/
        return Date.parse(value)
      end
      day, month, year = value.split('.').map {|s| s.to_i}
      month ||= Date.today.month
      year ||= Date.today.year
      year = expand_year(year, 2000)

      return Date.new(year, month, day)
    else
      return value
    end
  end

  def self.date_only_year?(value)
    value.is_a?(String) and value.strip.match /^\d{2,4}$/
  end

  def self.expand_year(value, base = 1900)
    year = value.to_i
    return year < 100 ? year + base : year
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
        logger.info("lp -h #{cups_host} -d #{device}")
        generator = IO.popen("lp -h #{cups_host} -d #{device}", "w+")
        generator.puts render_to_pdf(:template => "#{controller_name}/#{method}.html.erb", :layout => 'simple', :media => media)
        generator.close_write

        # Just read to not create zombie processes... TODO: fix
        data = generator.read
        generator.close

#        render :text => "<p>Gedruckt.</p>"
      end
    end
  end
end

ActionController::Base.send :include, Print
