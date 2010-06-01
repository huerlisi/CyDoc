class InsurancesController < ApplicationController
  # GET /insurances
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    if params[:all]
      @insurances = Insurance.paginate(:page => params['page'])
    else
      @insurances = Insurance.clever_find(query).paginate(:page => params['page'])
    end
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

  # GET /insurances/1
  def show
    @insurance = Insurance.find(params[:id])
  end
end
