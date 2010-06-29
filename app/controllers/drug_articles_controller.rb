class DrugArticlesController < ApplicationController
  # GET /drug_articles/new
  def new
    @drug_product = DrugProduct.find(params[:drug_product_id])
    @drug_article = @drug_product.drug_articles.build(params[:drug_article])

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'drug_article_view', :partial => 'new'
          page.replace_html 'search_results', ''
        end
      }
    end
  end

  # POST /drug_articles
  def create
    @drug_product = DrugProduct.find(params[:drug_product_id])
    @drug_article = @drug_product.drug_articles.build(params[:drug_article])
    
    if @drug_article.save
      flash[:notice] = 'Medikamentenpackung erfasst.'
      respond_to do |format|
        format.html {
          redirect_to @drug_article
        }
        format.js {
          render :update do |page|
            page.replace_html 'drug_article_list', :partial => 'list'
            page.replace_html 'drug_article_view', ''
          end
        }
      end
    else
      respond_to do |format|
        format.html {
          render :action => :new
        }
        format.js {
          render :update do |page|
            page.replace_html 'drug_article_view', :partial => 'new'
          end
        }
      end
    end
  end
end
