class DoctorsController < ApplicationController
  inherit_resources

  respond_to :js

  # Phone Numbers
  in_place_edit_for :phone_number, :phone_number_type
  in_place_edit_for :phone_number, :number

  # GET /patients
  def index
    query = params[:search][:query] if params[:search]

    if query.present?
      @doctors = Doctor.clever_find(query).paginate(:page => params['page'])
    else
      @doctors = Doctor.paginate(:page => params['page'])
    end

    index!
  end

  def search
    query = params[:query] || params[:search][:query]
    query ||= params[:search][:query] if params[:search]
    @doctors = Doctor.clever_find(query)

    render :partial => 'list', :layout => false
  end

  def show
    @doctor = Doctor.find(params[:id])
  end

  # GET /posts/new
  def new
    doctor = params[:doctor]
    @doctor = Doctor.new(doctor)
    @doctor.build_vcard(params[:vcard])
  end

  def create
    @doctor = Doctor.new(params[:doctor])
    @doctor.build_vcard(params[:vcard])

    if @doctor.save
      flash[:notice] = 'Arzt gespeichert.'
      redirect_to @doctor
    else
      render :action => :new
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
    render :action => 'edit'
  end
  
  def update
    @doctor = Doctor.find(params[:id])

    @doctor.build_vcard unless @doctor.vcard

    if @doctor.update_attributes(params[:doctor]) && @doctor.vcard.update_attributes(params[:vcard])
      flash[:notice] = 'Arzt gespeichert.'
      redirect_to :action => :show, :id => @doctor
    else
      render :action => :new
    end
  end
end
