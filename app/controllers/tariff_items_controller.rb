class TariffItemsController < ApplicationController
  # GET /tariff_items
  def index
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @tariff_items = TariffItem.clever_find(query).paginate(:page => params['page'])

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

  def assign
    tariff_item = TariffItem.find(params[:id])
    session = Session.find(params[:session_id])
    patient = Patient.find(params[:patient_id])
    date = params[:date].blank? ? DateTime.now : Date.parse_europe(params[:date])
    
    service_record = tariff_item.create_service_record(patient, @current_doctor, date)

    # Handle TariffItemGroups
    if service_record.is_a? Array
      service_record.map{|record| record.save!}
    else
      service_record.save
    end
    flash[:notice] = 'Erfolgreich erfasst.'

    respond_to do |format|
      format.html {
        redirect_to :controller => 'patients', :action => 'show', :id => patient, :tab => 'services'
        return
      }
      format.js {
        render :update do |page|
          @patient = patient
          page.replace_html "session_#{session.id}", :partial => 'sessions/item', :object => session
#          page.replace_html 'search_results', ''
        end
      }
    end
  end

  def edit
  end

  def edit_inline
    edit
    render :action => 'edit', :layout => false
  end
end
