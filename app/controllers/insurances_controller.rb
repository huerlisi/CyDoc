# encoding: UTF-8
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

  # GET /insurances/new
  def new
    @insurance = Insurance.new(params[:insurance])
    @insurance.vcard = Vcard.new(params[:insurance])
  end

  # POST /insurances
  def create
    @insurance = Insurance.new
    @insurance.vcard = Vcard.new

    if @insurance.update_attributes(params[:insurance])
      flash[:notice] = 'Versicherung erfasst.'
      redirect_to @insurance
    else
      render :action => :new
    end
  end

  # GET /insurances/1/edit
  def edit
    @insurance = Insurance.find(params[:id])
  end

  # PUT /insurances/1
  def update
    @insurance = Insurance.find(params[:id])

    respond_to do |format|
      if @insurance.update_attributes(params[:insurance])
        flash[:notice] = 'Versicherung wurde geändert.'
        format.html { redirect_to(@insurance) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @insurance = Insurance.find(params[:id])

    @insurance.destroy
    redirect_to insurances_path
  end
end
