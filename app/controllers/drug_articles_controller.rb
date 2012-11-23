class DrugArticlesController < AuthorizedController
  belongs_to :drug_product, :optional => true
end
