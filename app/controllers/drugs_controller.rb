class DrugsController < ApplicationController
  # CRUD Actions

  # GET /drugs
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @substances = DrugSubstance.all
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
    @drug = DrugSubstance.find(params[:id])
  end
end
