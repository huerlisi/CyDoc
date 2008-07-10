class CasesController < ApplicationController

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
