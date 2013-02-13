# -*- encoding : utf-8 -*-

class TariffItem < ActiveRecord::Base
  # Access restrictions
  attr_accessible :code, :remark, :obligation, :amount_mt, :amount_tt, :type_as_string, :vat_class, :tariff_type

  # Associations
  belongs_to :vat_class
  belongs_to :imported, :polymorphic => true

  # Validations
  validates_presence_of :code, :remark

  #TODO
  def self.to_string
    I18n.translate(self.name.underscore, :scope => [:activerecord, :models])
  end

  def to_s(format = :default)
    [code, remark].compact.select{|item| not item.empty?}.join ' - '
  end

  def type_to_s
    self.class.to_s
  end

  def type_as_string
    read_attribute(:type)
  end

  def type_as_string=(value)
    write_attribute(:type, value)
  end

  # Search
  # ======
  def self.clever_find(query)
    return scoped if query.blank?

    query_params = {}
    case get_query_type(query)
    when "lab"
      query_params[:query] = "#{query}%"
      condition = "code LIKE :query"
    when "code"
      query_params[:query] = query.delete('.')
      condition = "REPLACE(code, '.', '') = :query"
    when "text"
      query_params[:query] = "%#{query}%"

      condition = "remark LIKE :query OR code LIKE :query"
    end

    self.where("(#{condition})", query_params).order("IF(type = 'TariffItemGroup', 0, 1), tariff_type DESC, code")
  end

  private
  def self.get_query_type(value)
    # Analyseliste: code ~ 1234.56
    if value.match(/^[[:digit:]]{4}$/)
      return "lab"
    elsif value.match(/^[[:digit:].]*$/)
      return "code"
    else
      return "text"
    end
  end

  public
  def service_record_class
    ServiceRecord
  end

  def create_service_record(session)
    # Type information
    service_record = service_record_class.new
    service_record.tariff_type = tariff_type

    # Remember session as it may influence tax points
    @session = session

    # Tariff data
    service_record.code = code

    service_record.amount_mt = amount_mt
    service_record.unit_mt = unit_mt
    service_record.unit_factor_mt = unit_factor_mt

    service_record.amount_tt = amount_tt
    service_record.unit_tt = unit_tt
    service_record.unit_factor_tt = unit_factor_tt

    service_record.remark = remark

    return service_record
  end

  # "Constant" fields
  def unit_mt
    0.89
  end

  def unit_tt
    0.89
  end

  def unit_factor_mt
    1.0
  end

  def unit_factor_tt
    1.0
  end

  # Fallbacks
  def amount_mt
    read_attribute(:amount_mt) || 0
  end

  def amount_tt
    read_attribute(:amount_tt) || 0
  end

  def tariff_type
    read_attribute(:tariff_type) || self.class.tariff_type
  end

  # Calculated field
  def amount
    (self.amount_mt * self.unit_factor_mt * self.unit_mt) + (self.amount_tt * self.unit_factor_tt * self.unit_tt)
  end

  def reason
    return nil unless @session

    @session.treatment.reason
  end
end
