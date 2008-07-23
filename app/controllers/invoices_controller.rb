class InvoicesController < ApplicationController
  def tarmed_rueckforderungsbeleg
    @invoice = Invoice.find(params[:id])
  end

  def tarmed
    @invoice = Invoice.find(params[:id])
  end

  def tarmed_for_pdf
    tarmed
    render :action => 'tarmed', :layout => 'simple'
  end

  def tarmed_rueckforderungsbeleg_for_pdf
    tarmed_rueckforderungsbeleg
    render :action => 'tarmed_rueckforderungsbeleg', :layout => 'simple'
  end

  # CRUD actions
  def new
    @invoice = Invoice.new
    @invoice.date = DateTime.now
    
    @tiers = Tiers.new
    @tiers.patient_id = params[:patient_id]
  end

  def new_inline
    new
    render :action => 'new', :layout => false
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    
    # Tiers
    @tiers = TiersGarant.new(params[:tiers])
    @tiers.biller_id = @current_doctor.id
    @tiers.provider_id = @current_doctor.id

    @tiers.save
    @invoice.tiers = @tiers

    # Law, TODO
    @law = Law.new(:insured_id => @tiers.patient.insurance_nr)
    @law.save
    @invoice.law = @law
    
    # Treatment
    @treatment = Treatment.new(:reason => 'disease', :canton => 'ZH')
    @treatment.date_begin = DateTime.now
    @treatment.date_end = DateTime.now
    @invoice.treatment = @treatment

    # Services
    @invoice.record_tarmeds = @tiers.patient.record_tarmeds
    
    if @invoice.save
      flash[:notice] = 'Erfolgreich generiert.'
      redirect_to :controller => 'patients', :action => 'show', :id => @tiers.patient_id
    else
      render :action => 'new'
    end
  end


end
