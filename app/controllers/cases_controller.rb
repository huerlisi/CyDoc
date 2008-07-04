class CasesController < ApplicationController

  def show
    @case = Case.find(params[:id])
  end
end
