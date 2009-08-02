class TariffItemsController < ApplicationController
  # GET /tariff_items
  def search
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @tariff_items = TariffItem.clever_find(query).paginate(:page => params['page'], :per_page => 25)
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
end
