class TariffItemsController < ApplicationController
  in_place_edit_for :tariff_item, :remark
  in_place_edit_for :tariff_item, :code

  in_place_edit_for :service_item, :ref_code
  in_place_edit_for :service_item, :quantity

  # Show single search match
  #
  # Cast match to TariffItem.
  def redirect_if_match(collection)
    if collection.size == 1
      respond_to do |format|
        format.html {
          redirect_to collection.first.becomes(TariffItem)
        }
        format.js {
          render :update do |page|
            page.redirect_to collection.first.becomes(TariffItem)
          end
        }
      end

      return true
    else
      return false
    end
  end

  # GET /tariff_items
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    if query.present?
      @tariff_items = TariffItem.clever_find(query).paginate(:page => params['page'], :per_page => 25)

      # Show selection list only if more than one hit
      return if !params[:all] && redirect_if_match(@tariff_items)
    else
      @tariff_items = TariffItem.paginate(:page => params['page'], :per_page => 25)
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

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'tariff_item_view', :partial => 'new'
          page.replace_html 'search_results', ''
        end
      }
    end
  end

  # POST /tariff_items
  def create
    @tariff_item = TariffItem.new(params[:tariff_item])

    if @tariff_item.save
      # Hack to cast @tariff_item to correct subclass if type changed
      @tariff_item = @tariff_item.becomes(@tariff_item.type.constantize)

      flash[:notice] = 'Leistung erfasst.'
      respond_to do |format|
        format.html {
          redirect_to @tariff_item
        }
        format.js {
          render :update do |page|
            page.replace_html 'tariff_item_view', :partial => 'show'
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
            page.replace_html 'tariff_item_view', :partial => 'new'
          end
        }
      end
    end
  end

  # GET /tariff_item/1/edit
  def edit
    @tariff_item = TariffItem.find(params[:id])

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'tariff_item_view', :partial => 'edit'
        end
      }
    end
  end

  # PUT /tariff_item/1
  def update
    @tariff_item = TariffItem.find(params[:id])

    if @tariff_item.update_attributes(params[:tariff_item])
      # Hack to cast @tariff_item to correct subclass if type changed
      @tariff_item = @tariff_item.becomes(@tariff_item.type.constantize)

      respond_to do |format|
        format.html {
          render :action => :show
        }
        format.js {
          render :update do |page|
            page.replace_html 'tariff_item_view', :partial => 'show'
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
            page.replace_html 'tariff_item_view', :partial => 'edit'
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

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'tariff_item_view', :partial => 'new'
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
      format.html { redirect_to tariff_items_path}
      format.js {
        render :update do |page|
          page.redirect_to tariff_items_url
        end
      }
    end
  end
end
