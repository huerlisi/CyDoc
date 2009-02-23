class TariffItemsController < ApplicationController
  def list_for_service_record_code
    if params[:search_query].blank?
      render :text => 'Kein Suchbegriff angegeben.'
      return
    end
    
    code = params[:search_query].downcase
    if code.split(' ').size > 1
      query = code.split(' ').join('%')
      query_switched = code.split(' ').reverse.join('%')
    else
      query = code
      query_switched = code
    end
    
    @tarmed_texts = Tarmed::LeistungText.find(:all, :joins => :digniquali,
      :conditions => [ "( LEISTUNG_TEXT.LNR LIKE :query OR BEZ_255 LIKE :query OR BEZ_255 LIKE :query_switched )AND LEISTUNG_TEXT.GUELTIG_BIS = :valid_to AND SPRACHE = 'D' AND QL_DIGNITAET IN ('0400', '9999')",
      {:query => '%' + query + '%', :query_switched => '%' + query_switched + '%', :valid_to => '12/31/99 00:00:00'}],
      :order => 'LEISTUNG_TEXT.LNR',
      :limit => 15)

    render :partial => 'tarmed_table_item'
  end

  # CRUD actions
  def index
    redirect_to :action => :list
  end

  def list
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @tariff_items = TariffItem.paginate(:page => params['page'], :per_page => 20, :conditions => ['code LIKE :query OR remark LIKE :query', {:query => "%#{query}%"}], :order => 'code')

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
  
  def new
    @service_record = ServiceRecord.new

    # Defaults
    @service_record.date = Date.today
    @service_record.quantity = 1
    @service_record.provider = @current_doctor
    @service_record.responsible = @current_doctor

    @service_record.patient_id = params[:patient_id]

    respond_to do |format|
      format.html {
        render
        return
      }
      format.js {
        render :layout => false
      }
    end
  end

  def create
    tariff_item = TariffItem.find(params[:id])
    patient = Patient.find(params[:patient_id])

    service_record = tariff_item.create_service_record(patient, @current_doctor)

    # Handle TariffItemGroups
    if service_record.is_a? Array
      service_record.map{|record| record.save!}
    else
      service_record.save
    end
    flash[:notice] = 'Erfolgreich erfasst.'
    redirect_to :controller => 'patients', :action => 'show', :id => patient
  end

  def edit
  end

  def edit_inline
    edit
    render :action => 'edit', :layout => false
  end

  def delete
    ServiceRecord.destroy(params[:id])
    redirect_to :action => 'list'
  end

  def delete_inline
    ServiceRecord.destroy(params[:id])
    redirect_to :action => 'list_inline', :patient_id => params[:patient_id]
  end
end
