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

  # GET /drug_article/1/edit
  def edit
    @drug_article = DrugArticle.find(params[:id])
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'drug_article_view', :partial => 'edit'
        end
      }
    end
  end
  
  # PUT /drug_article/1
  def update
    @drug_article = DrugArticle.find(params[:id])
    
    if @drug_article.update_attributes(params[:drug_article])
      respond_to do |format|
        format.html {
          render :action => :show
        }
        format.js {
          render :update do |page|
            page.replace "drug_article_#{@drug_article.id}", :partial => 'item', :object => @drug_article
            page.replace_html 'drug_article_view', ''
          end
        }
      end
    else
      respond_to do |format|
        format.html {
          render :action => :edit
        }
        format.js {
          render :update do |page|
            page.replace_html 'drug_article_view', :partial => 'edit'
          end
        }
      end
    end
  end

  # DELETE /drug_article/1
  def destroy
    @drug_article = DrugArticle.find(params[:id])

    @drug_article.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "drug_article_#{@drug_article.id}"
        end
      }
    end
  end

end
