class DrugsController < ApplicationController
  # CRUD Actions

  # GET /drugs
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    if params[:all]
      @drugs = DrugProduct.paginate(:page => params['page'], :order => 'id DESC')
    else
      @drugs = DrugProduct.clever_find(query).paginate(:page => params['page'], :order => 'id DESC')
    end

    # Show selection list only if more than one hit
    if @drugs.size == 1
      params[:id] = @drugs.first.id
      show
      return
    end
      
    respond_to do |format|
      format.html { }
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
