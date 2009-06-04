class TariffItemsController < ApplicationController
  # CRUD actions
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

  def new
    @service_record = ServiceRecord.new

    # Defaults
    @service_record.date = Date.today
    @service_record.quantity = 1
    @service_record.provider = @current_doctor
    @service_record.responsible = @current_doctor

    @service_record.patient_id = params[:patient_id]

    respond_to do |format|
      format.html { }
      format.js {
        render :partial => 'form'
      }
    end
  end

  def assign
    tariff_item = TariffItem.find(params[:id])
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
          page.replace_html 'service_list', :partial => 'service_records/list', :locals => { :items => patient.service_records}
          page.replace_html 'search_results', ''
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

  # DELETE 
  def destroy
    service_record = ServiceRecord.find(params[:id])
    patient = service_record.patient
    service_record.destroy
    
    respond_to do |format|
      format.html {
        redirect_to :controller => 'patients', :action => 'show', :id => patient, :tab => 'services'
        return
      }
      format.js {
        render :partial => 'service_records/list', :locals => { :items => patient.service_records}
      }
    end
  end
end
