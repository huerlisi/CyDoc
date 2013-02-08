# encoding: utf-8'
class SearchController < ApplicationController
  def index
    query = params[:query]

    case query
    when /B?([0-9]{8})/
      # CaseCode
      code = $1
      cases = Case.where(:praxistar_eingangsnr => code)
      if cases.exists?
        redirect_to cases.first
      end
    end

    @collection = Patient.by_text(query, :star => true, :per_page => 30, :page => params[:page])
  end
end
