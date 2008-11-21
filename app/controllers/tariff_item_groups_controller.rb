class TariffItemGroupsController < ApplicationController
  # CRUD Actions
  def index
    redirect_to :action => :list
  end
  
  def list
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @tariff_item_groups = TariffItemGroup.find :all, :order => 'name'
  end

  def search
    query = params[:query] || params[:search][:query]
    query ||= params[:search][:query] if params[:search]
    @tariff_item_groups = TariffItemGroup.find(:all, :conditions => ['name LIKE ?', "%#{query}%"])

    render :partial => 'list', :layout => false
  end

  def show
    @tariff_item_groups = TariffItemGroup.find(params[:id])
  end
end
