class ServiceRecordsController < ApplicationController
  # GET /service_records/new
  def new
    @service_record = ServiceRecord.new

    # Defaults
    @service_record.date = Date.today
    @service_record.quantity = 1

    respond_to do |format|
      format.html { }
      format.js {
        render :partial => 'form'
      }
    end
  end

  def create
    tariff_item = TariffItem.find(params[:tariff_item_id])
    @patient = Patient.find(params[:patient_id])
    @session = Session.find(params[:session_id])

    service_record = @session.build_service_record(tariff_item)

    service_record.date = params[:date].blank? ? DateTime.now : Date.parse_europe(params[:date])
    
    # Handle TariffItemGroups
    if service_record.is_a? Array
      service_record.map{|record| record.save!}
    else
      service_record.save
    end
    flash[:notice] = 'Erfolgreich erfasst.'

    respond_to do |format|
      format.html {
        redirect_to :controller => 'patients', :action => 'show', :id => @patient, :tab => 'services'
        return
      }
      format.js {
        render :update do |page|
          page.replace_html "session_#{@session.id}", :partial => 'sessions/item', :object => @session
#          page.replace_html 'search_results', ''
        end
      }
    end
  end

  # GET /service_records/select
  def select
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @tariff_items = TariffItem.clever_find(query).paginate(:page => params['page'])

    respond_to do |format|
      format.html {
        render :action => 'select_list'
        return
      }
      format.js {
        render :update do |page|
          page.replace_html 'search_results', :partial => 'select_list'
        end
      }
    end
  end

end
