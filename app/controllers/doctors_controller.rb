class DoctorsController < ApplicationController
  # CRUD Actions
  def index
    redirect_to :action => :list
  end
  
  def list
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @doctors = Doctor.by_name(query)
  end

  def search
    query = params[:query] || params[:search][:query]
    query ||= params[:search][:query] if params[:search]
    @doctors = Doctor.by_name("%#{query}%")

    render :partial => 'list', :layout => false
  end
end
