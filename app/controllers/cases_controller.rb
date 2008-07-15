class CasesController < ApplicationController
  # Authorization
  # =============
  before_filter :authorize

  private
  def authorize
    begin
      Case.find(params[:id], :conditions => ['doctor_id = ?', @current_doctor.id])
    rescue ActiveRecord::RecordNotFound
      render :partial => 'shared/access_denied', :layout => 'cases', :status => 404
    end
  end

  # Actions
  # =======
  public
  def show
    @case = Case.find(params[:id])
    @related_cases = @case.patient.cases.find(:all, :conditions => ['doctor_id = ?', @current_doctor.id])
  end

  def show_inline
    show
    render :action => 'show', :layout => false
  end

  def result_remarks
    @case = Case.find(params[:id])
    send_file(@case.order_form.file('result_remarks'), :type => 'image/jpeg', :disposition => 'inline')
  end

  def order_form_inline
    render :partial => 'order_form'
  end

  def order_form
    @case = Case.find(params[:id])
    send_file(@case.order_form.file, :type => 'image/jpeg', :disposition => 'inline')
  end

  def pdf_a4
    @case = Case.find(params[:id])
    send_file(File.join(RAILS_ROOT, '/data/result_reports/', "result_report-#{@case.id}.pdf"), :type => 'application/pdf', :disposition => 'inline')
  end
end
