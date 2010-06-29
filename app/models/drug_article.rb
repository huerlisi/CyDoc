class DrugArticle < ActiveRecord::Base
  # Associations
  belongs_to :drug_product
  belongs_to :vat_class
  has_many :drug_prices, :dependent => :destroy
  
  # Validations
  validates_presence_of :code, :name, :description
  
  # General
  def to_s
    "#{code} - #{name}"
  end

  # Search
  def self.clever_find(query, *args)
    return [] if query.nil? or query.empty?

    query_params = {}
    
    query_params[:query] = "%#{query}%"
    
    find(:all, :conditions => ["name LIKE :query OR description LIKE :query", query_params], :order => 'name')
  end
  
  # Prices
  def price
    begin
      return drug_prices.valid.public.current.first.price
    rescue
      return 0.0
    end
  end

  def doctors_price
    begin
      # TODO: there could be more than one price (PPHA + PEXF etc.)
      return drug_prices.valid.doctor.current.first.price
    rescue
      return 0.0
    end
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
    tariff_item = DrugTariffItem.find(:first, :conditions => {:tariff_type => "400", :code => code})
    
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
