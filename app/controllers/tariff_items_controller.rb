# -*- encoding : utf-8 -*-
class TariffItemsController < AuthorizedController
  has_scope :clever_find

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
end
