class DrugsController < ApplicationController
  # CRUD Actions

  # GET /drugs
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @drugs = DrugProduct.clever_find(query).paginate(:page => params['page'], :order => 'id DESC')
    respond_to do |format|
      format.html {
        render :action => 'list'
        return
      }
      format.js {
        render :update do |page|
          page.replace_html 'search_results', :partial => 'list'
        end
      }
    end
  end

  # GET /drugs/1
  def show
    @drug = DrugProduct.find(params[:id])
  end

  def create_tariff_item
    @drug = DrugProduct.find(params[:id])
    
    for drug_article in @drug.drug_articles
      tariff_item = drug_article.build_tariff_item
      tariff_item.save!
    end
    redirect_to :action => :show
  end
end
