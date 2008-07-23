class MedicalCasesController < ApplicationController
  def show
  end

  def show_inline
  end

  def edit
  end

  def edit_inline
  end

  def new
    @medical_case = Object.const_get(params[:type]).new

    @medical_case.date = Date.today
    @medical_case.doctor = @current_doctor
    @medical_case.patient_id = params[:patient_id]
  end

  def new_inline
    new
    render :action => 'new', :layout => false
  end

  def create
    @medical_case = Object.const_get(params[:medical_case][:type]).new(params[:medical_case])
    if @medical_case.save
      flash[:notice] = 'Erfolgreich erfasst.'
      redirect_to :controller => 'patients', :action => 'show', :id => @medical_case.patient_id
    else
      render :action => 'new'
    end
  end
end
