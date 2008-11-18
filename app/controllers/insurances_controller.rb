class InsurancesController < ApplicationController
  # CRUD Actions
  def index
    redirect_to :action => :list
  end
  
  def list
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @insurances = Insurance.find :all, :joins => :vcard, :order => 'full_name'
  end

  def search
    query = params[:query] || params[:search][:query]
    query ||= params[:search][:query] if params[:search]
    @insurances = Insurance.by_name("%#{query}%")

    render :partial => 'list', :layout => false
  end

  def show
    @insurance = Insurance.find(params[:id])
  end
end
