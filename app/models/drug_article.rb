class DrugArticle < ActiveRecord::Base
  belongs_to :drug_product
  belongs_to :vat_class
  
  def to_s
    "#{code} - #{name}"
  end
end
