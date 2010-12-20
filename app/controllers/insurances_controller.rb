class InsurancesController < ApplicationController
  # GET /insurances
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    if query.present?
      @insurances = Insurance.clever_find(query).paginate(:page => params['page'])
    else
      @insurances = Insurance.paginate(:page => params['page'])
    end

    # Show selection list only if more than one hit
    return if !params[:all] && redirect_if_match(@insurances)
    
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
