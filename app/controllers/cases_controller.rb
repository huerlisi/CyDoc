class CasesController < ApplicationController

  def show
    @case = Case.find(params[:id])
  end

  def result_report
    show
    render :action => :show
  end
end
