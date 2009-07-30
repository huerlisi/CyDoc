class ServiceRecordsController < ApplicationController
  in_place_edit_for :session, :date
  in_place_edit_for :service_record, :ref_code
  in_place_edit_for :service_record, :quantity

  # GET /service_records/new
  def new
    @service_record = ServiceRecord.new

    # Defaults
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
          page.replace_html "treatment_#{@session.treatment.id}_service_list_total", "Total: #{@session.treatment.amount.currency_round}"
        end
      }
    end
  end

  # GET /service_records/select
  def select
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @tariff_items = TariffItem.clever_find(query).paginate(:page => params['page'])
    @patient = Patient.find(params[:patient_id])
    @session = Session.find(params[:session_id])
    
    # Show selection list only if more than one hit
    if @tariff_items.size == 1
      params[:tariff_item_id] = @tariff_items.first.id
      create
      return
    end
      
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

  # DELETE 
  def destroy
    service_record = ServiceRecord.find(params[:id])
    @patient = Patient.find(params[:patient_id])
    @session = Session.find(params[:session_id])

    service_record.destroy
    
    respond_to do |format|
      format.html {
        redirect_to :controller => 'patients', :action => 'show', :id => @patient, :tab => 'services'
        return
      }
      format.js {
        render :update do |page|
          page.replace_html "session_#{@session.id}", :partial => 'sessions/item', :object => @session
          page.replace_html "treatment_#{@session.treatment.id}_service_list_total", "Total: #{@session.treatment.amount.currency_round}"
        end
      }
    end
  end
end
