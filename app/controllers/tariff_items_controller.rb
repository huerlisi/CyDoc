class TariffItemsController < ApplicationController
  in_place_edit_for :tariff_item, :remark
  in_place_edit_for :tariff_item, :code

  in_place_edit_for :service_item, :ref_code
  in_place_edit_for :service_item, :quantity

  # GET /tariff_items
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    if params[:all]
      @tariff_items = TariffItem.paginate(:page => params['page'], :per_page => 25)
    else
      @tariff_items = TariffItem.clever_find(query).paginate(:page => params['page'], :per_page => 25)
    end
    
    # Show selection list only if more than one hit
    if @tariff_items.size == 1
      params[:id] = @tariff_items.first.id
      show
      return
    end
      
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'search_results', :partial => 'list'
          page.replace_html 'tariff_item_view', ''
        end
      }
    end
  end

  # GET /tariff_items/new
  def new
    @tariff_item = TariffItem.new(params[:tariff_item])
  end

  # POST /tariff_items
  def create
    @tariff_item = TariffItem.new(params[:tariff_item])
    
    if @tariff_item.save
      flash[:notice] = 'Leistung erfasst.'
      redirect_to @tariff_item
    else
      render :action => :new
    end
  end

  # GET /tariff_item/1/edit
  def edit
    @tariff_item = TariffItem.find(params[:id])
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.insert_html :after, "tariff_item_#{@tariff_item.id}", :partial => 'form'
        end
      }
    end
  end
  
  # PUT /tariff_item/1
  def update
    @tariff_item = TariffItem.find(params[:id])
    
    if @tariff_item.update_attributes(params[:tariff_item])
      respond_to do |format|
        format.html {
          render :action => :show
        }
        format.js {
          render :update do |page|
            page.replace "tariff_item_#{@tariff_item.id}", :partial => 'item', :object => @tariff_item
            page.remove "tariff_item_form"
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
            page.replace 'recall_form', :partial => 'recalls/form'
          end
        }
      end
    end
  end

  # GET /tariff_item/id
  def show
    @tariff_item = TariffItem.find(params[:id])
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'tariff_item_view', :partial => 'show'
          page.replace_html 'search_results', ''
        end
      }
    end
  end

  # POST /tariff_item/1/duplicate
  def duplicate
    @orig_tariff_item = TariffItem.find(params[:id])
    
    @tariff_item = @orig_tariff_item.clone
    # TODO: fix to prevent collition on second cloning
    @tariff_item.code += " (Kopie)"
    
    @tariff_item.save!
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'tariff_item_view', :partial => 'show'
          page.replace_html 'search_results', ''
        end
      }
    end
  end
  
  # DELETE /tariff_item/1
  def destroy
    @tariff_item = TariffItem.find(params[:id])

    @tariff_item.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.redirect_to tariff_items_url
        end
      }
    end
  end
end
