class TariffItemsController < ApplicationController
  def auto_complete_for_record_tarmed_code
    @tarmed_texts = Tarmed::LeistungText.find(:all,
      :conditions => [ 'LNR LIKE :query OR BEZ_255 LIKE :query AND GUELTIG_BIS = :valid_to AND SPRACHE = \'D\'',
      {:query => '%' + params[:record_tarmed][:code].downcase + '%', :valid_to => '12/31/99 00:00:00'}],
      :order => 'LNR',
      :limit => 5)

    @hidden_item_count = @tarmed_texts.size - 5
    render :partial => 'tarmed_item'
  end

  # CRUD actions
  def list
  end
  
  def list_inline
    @patient = Patient.find(params[:patient_id])
    @record_tarmeds = RecordTarmed.find(:all, :conditions => {:patient_id => @patient})
    render :partial => 'list', :locals => {:items => @record_tarmeds}
  end

  def new
    @record_tarmed = RecordTarmed.new
    @record_tarmed.provider_id = @current_doctor.id

    # Defaults
    @record_tarmed.date = Date.today
    @record_tarmed.quantity = 1
    @record_tarmed.responsible_id = @current_doctor.id

    @record_tarmed.patient_id = params[:patient_id]
  end

  def new_inline
    new
    render :action => 'new', :layout => false
  end

  def create
    params[:record_tarmed][:code] = params[:record_tarmed][:code].split(' ')[0]
    @record_tarmed = RecordTarmed.new(params[:record_tarmed])
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
