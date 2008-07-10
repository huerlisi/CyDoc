class CasesController < ApplicationController
  # Authorization
  # =============
  before_filter :authorize
  private
  def authorize
    begin
      Case.find(params[:id], :conditions => ['doctor_id = ?', @current_doctor.id])
    rescue ActiveRecord::RecordNotFound
      render :text => 'Fall existiert nicht oder Sie haben keine Berechtigung', :status => 404
    end
  end

  # Actions
  # =======
  public
  def show
    @case = Case.find(params[:id])
  end

  def result_report
    show
    render :action => :show
  end

  def order_form
    @case = Case.find(params[:id])
    send_file(@case.order_form.file('result_remarks'), :type => 'image/jpeg', :disposition => 'inline')
  end
end
