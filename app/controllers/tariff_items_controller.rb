class TariffItemsController < ApplicationController
  # GET /tariff_items
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @tariff_items = TariffItem.clever_find(query).paginate(:page => params['page'])

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
  
  alias :search :index

  def edit
  end

  def edit_inline
    edit
    render :action => 'edit', :layout => false
  end
end
