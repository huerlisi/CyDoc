class DrugArticle < ActiveRecord::Base
  belongs_to :drug_product
  belongs_to :vat_class
  has_many :drug_prices, :dependent => :destroy
  
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
  end
end
