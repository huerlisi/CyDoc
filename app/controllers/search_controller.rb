# -*- encoding : utf-8 -*-
class SearchController < ApplicationController
  def results
    value = params[:query]
    value ||= params[:search][:query] if params[:search]
    value ||= params[:quick_search][:query] if params[:quick_search]

    # Set default param for rendering in result view
    params[:query] = value
    @patients = Patient.clever_find(value)

    render :template => 'patients/list'
  end
end
