class DrugsController < ApplicationController
  # CRUD Actions

  # GET /drugs
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @drugs = DrugProduct.clever_find(query)
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
end
