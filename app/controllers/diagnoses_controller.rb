class DiagnosesController < ApplicationController
  # CRUD actions
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @diagnoses = Diagnosis.paginate(:page => params['page'], :per_page => 20, :conditions => ['code LIKE :query OR text LIKE :query', {:query => "%#{query}%"}], :order => 'code')

    respond_to do |format|
      format.html {
        render :action => 'list'
        return
      }
      format.js {
        render :update do |page|
          page.replace_html 'search_results', :partial => 'list'
        end
      }
    end
  end
  
  alias :search :index
end
