class DrugProductsController < ApplicationController
  # CRUD Actions

  # GET /drug_products
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    if params[:all]
      @drug_products = DrugProduct.paginate(:page => params['page'], :order => 'id DESC')
    else
      @drug_products = DrugProduct.clever_find(query).paginate(:page => params['page'], :order => 'id DESC')
    end

    # Show selection list only if more than one hit
    if @drug_products.size == 1
      params[:id] = @drug_products.first.id
      show
      return
    end
      
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'search_results', :partial => 'list'
          page.replace_html 'drug_product_view', ''
        end
      }
    end
  end

  # GET /drug_products/1
  def show
    @drug_product = DrugProduct.find(params[:id])

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'drug_product_view', :partial => 'show'
          page.replace_html 'search_results', ''
        end
      }
    end
  end

  # GET /drug_products/new
  def new
    @drug_product = DrugProduct.new(params[:drug])

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'drug_product_view', :partial => 'new'
          page.replace_html 'search_results', ''
        end
      }
    end
  end

  # POST /drug_products
  def create
    @drug_product = DrugProduct.new(params[:drug_product])
    
    if @drug_product.save
      flash[:notice] = 'Medikament erfasst.'
      respond_to do |format|
        format.html {
          redirect_to @drug_product
        }
        format.js {
          render :update do |page|
            page.replace_html 'drug_product_view', :partial => 'show'
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
            page.replace_html 'drug_product_view', :partial => 'new'
          end
        }
      end
    end
  end

  # GET /drug_product/1/edit
  def edit
    @drug_product = DrugProduct.find(params[:id])
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'drug_product_view', :partial => 'edit'
        end
      }
    end
  end
  
  # PUT /drug_product/1
  def update
    @drug_product = DrugProduct.find(params[:id])
    
    if @drug_product.update_attributes(params[:drug_product])
      respond_to do |format|
        format.html {
          render :action => :show
        }
        format.js {
          render :update do |page|
            page.replace_html 'drug_product_view', :partial => 'show'
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
            page.replace_html 'drug_product_view', :partial => 'edit'
          end
        }
      end
    end
  end

  # DELETE /drug_product/1
  def destroy
    @drug_product = DrugProduct.find(params[:id])

    @drug_product.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.redirect_to drug_products_path
        end
      }
    end
  end
  
  # PUT /drug_produc/1/create_tariff_item
  def create_tariff_item
    @drug_product = DrugProduct.find(params[:id])
    
    for drug_article in @drug_product.drug_articles
      tariff_item = drug_article.build_tariff_item
      tariff_item.save!
    end

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'drug_product_view', :partial => 'show'
        end
      }
    end
  end
end
