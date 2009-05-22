class InsurancesController < ApplicationController
  # GET /insurances
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @insurances = Insurance.by_name("%#{query}%").paginate(:page => params['page'])
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
