class TariffItemsController < ApplicationController
  def list_for_record_tarmed_code
    code = params[:query].downcase
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

    unless query.nil? or query.empty?
      @tariff_items = TariffItem.find(:all, :conditions => ['code LIKE :query OR remark LIKE :query', {:query => "%#{query}%"}], :order => 'code')
    else
      @tariff_items = []
    end
  end
  
  def list_inline
    @patient = Patient.find(params[:patient_id])
    @tariff_items = @patient.service_records
    render :partial => 'service_records/list', :locals => {:items => @tariff_items}
  end

  def search
    query = params[:query] || params[:search][:query]
    query ||= params[:search][:query] if params[:search]

    unless query.nil? or query.empty?
      @tariff_items = TariffItem.find(:all, :conditions => ['code LIKE :query OR remark LIKE :query', {:query => "%#{query}%"}], :order => 'code')
    else
      @tariff_items = []
    end

    render :partial => 'list', :layout => false
  end

  def new
    @record_tarmed = RecordTarmed.new

    # Defaults
    @record_tarmed.date = Date.today
    @record_tarmed.quantity = 1
    @record_tarmed.provider = @current_doctor
    @record_tarmed.responsible = @current_doctor

    @record_tarmed.patient_id = params[:patient_id]
  end

  def new_inline
    new
    render :action => 'new', :layout => false
  end

  def create
    @record_tarmed = RecordTarmed.new(params[:record_tarmed])

    # Defaults
    @record_tarmed.date = Date.today
    @record_tarmed.quantity = 1
    @record_tarmed.responsible = @current_doctor
    @record_tarmed.provider = @current_doctor

    if @record_tarmed.save
      flash[:notice] = 'Erfolgreich erfasst.'
      redirect_to :controller => 'patients', :action => 'show', :id => @record_tarmed.patient_id
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def edit_inline
    edit
    render :action => 'edit', :layout => false
  end

  def delete
    RecordTarmed.destroy(params[:id])
    redirect_to :action => 'list'
  end

  def delete_inline
    RecordTarmed.destroy(params[:id])
    redirect_to :action => 'list_inline', :patient_id => params[:patient_id]
  end
end
