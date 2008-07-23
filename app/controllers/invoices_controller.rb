class InvoicesController < ApplicationController
  def insurance_recipe
    @invoice = Invoice.find(params[:id])
  end

  def patient_letter
    @invoice = Invoice.find(params[:id])
  end

  def patient_letter_for_pdf
    patient_letter
    render :action => 'patient_letter', :layout => 'simple'
  end

  def insurance_recipe_for_pdf
    insurance_recipe
    render :action => 'insurance_recipe', :layout => 'simple'
  end

  # CRUD actions
  def show
    @invoice = Invoice.find(params[:id])
  end

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
      redirect_to :controller => 'invoices', :action => 'insurance_recipe', :id => @invoice
    else
      render :action => 'new'
    end
  end


end
