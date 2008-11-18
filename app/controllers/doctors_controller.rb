class DoctorsController < ApplicationController
  # CRUD Actions
  def index
    redirect_to :action => :list
  end
  
  def list
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @doctors = Doctor.find :all, :joins => :praxis, :order => 'family_name'
  end

  def search
    query = params[:query] || params[:search][:query]
    query ||= params[:search][:query] if params[:search]
    @doctors = Doctor.by_name("%#{query}%")

    render :partial => 'list', :layout => false
  end

  def show
    @doctor = Doctor.find(params[:id])
    @account = @doctor.account
    @praxis = @doctor.praxis
  end

  def create
    @doctor = Doctor.new(params[:doctor])
    @account = @doctor.build_account(params[:account])
    @praxis = @doctor.build_praxis(params[:praxis])

    if @doctor.save
      flash[:notice] = 'Arzt gespeichert.'
      redirect_to :action => :show, :id => @doctor
    else
      render :action => :new
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
    @account = @doctor.account
    @praxis = @doctor.praxis
    render :action => 'edit'
  end
  
  def update
    @doctor = Doctor.find(params[:id])

    if @doctor.update_attributes(params[:doctor]) && @doctor.account.update_attributes(params[:account]) && @doctor.praxis.update_attributes(params[:praxis])
      flash[:notice] = 'Arzt gespeichert.'
      redirect_to :action => :show, :id => @doctor
    else
      render :action => :new
    end
  end
end
