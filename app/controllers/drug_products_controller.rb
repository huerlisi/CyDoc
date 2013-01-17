# -*- encoding : utf-8 -*-
class DrugProductsController < AuthorizedController
  # PUT /drug_produc/1/create_tariff_item
  def create_tariff_item
    @drug_product = DrugProduct.find(params[:id])

    for drug_article in @drug_product.drug_articles
      tariff_item = drug_article.build_tariff_item
      tariff_item.save!
    end

    redirect_to @drug_product
  end
end
