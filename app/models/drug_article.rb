# -*- encoding : utf-8 -*-

class DrugArticle < ActiveRecord::Base
  # Access restrictions
  attr_accessible :code, :description, :number_of_pieces, :quantity, :quantity_unit, :vat_class_id, :vat_class, :doctors_price, :price

  # Constants
  QUANTITY_UNITS = ["Stück", "ml", "g", "m", "Paar", "kg", "l", "Beutel", "Dosen", "mg", "Platten", "Blätter", "dl", "Becher", "Zäpfchen", "Vaginal Zäpfchen"]

  # Associations
  belongs_to :drug_product
  belongs_to :vat_class
  has_many :drug_prices, :dependent => :destroy, :autosave => true

  # Validations
  validates_presence_of :code, :name, :description
  validates_presence_of :number_of_pieces, :quantity, :quantity_unit
  validates_presence_of :vat_class

  # General
  def to_s
    "#{code} - #{description}"
  end

  # Calculations
  def description=(value)
    write_attribute(:description, value)
    write_attribute(:name, value.upcase)
  end

  # Search
  def self.clever_find(query, *args)
    return [] if query.nil? or query.empty?

    query_params = {}

    query_params[:query] = "%#{query}%"

    self.all(:conditions => ["name LIKE :query OR description LIKE :query", query_params], :order => 'name')
  end

  # Prices
  def price
    begin
      return drug_prices.public.current.first.price
    rescue
      return 0.0
    end
  end

  def price=(value)
    drug_price = drug_prices.public.current.first
    drug_price ||= drug_prices.build(:valid_from => Date.today, :price_type => 'PPUB')

    drug_price.price = value
    drug_price.save unless drug_price.new_record?
  end

  # Actually returns any wholesale price, not just doctors
  def doctors_price
    begin
      # TODO: there could be more than one price (PPHA + PEXF etc.)
      return drug_prices.wholesale.current.first.price
    rescue
      return 0.0
    end
  end

  def doctors_price=(value)
    drug_price = drug_prices.doctor.current.first
    drug_price ||= drug_prices.build(:valid_from => Date.today, :price_type => 'PDOC')

    drug_price.price = value
    drug_price.save unless drug_price.new_record?
  end

  # Tariff Items
  def build_tariff_item
    tariff_item = DrugTariffItem.new(
      :amount_mt   => price,
      :vat_class   => vat_class,
      :obligation  => !insurance_limited,
      :code        => code,
      :remark      => description,
      :tariff_type => "400"
    )

    tariff_item.imported = self

    return tariff_item
  end

  def build_or_update_tariff_item
    tariff_item = DrugTariffItem.first(:conditions => {:tariff_type => "400", :code => code})

    return build_tariff_item unless tariff_item

    puts "Updating #{tariff_item}..."

    tariff_item.amount_mt  = price
    tariff_item.vat_class  = vat_class
    tariff_item.obligation = !insurance_limited
    tariff_item.remark     = description

    tariff_item.imported   = self

    changes = tariff_item.changes.map{|column, values| "  #{column}: #{values[0]} => #{values[1]}"}.join("\n")
    puts changes

    return tariff_item
  end
end
