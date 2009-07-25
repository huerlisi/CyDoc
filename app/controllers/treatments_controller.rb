class TreatmentsController < ApplicationController
  def show
    @treatment = Treatment.find(params[:id])
    
    redirect_to :controller => :patients, :action => :show, :id => @treatment.patient_id, :tab => 'treatments', :sub_tab => "treatments_#{@treatment.id}"
  end

  def new
    @treatment = Treatment.new
    @treatment.date_begin = Date.today
    
    respond_to do |format|
      format.html { }
      format.js {
        render :partial => 'form'
      }
    end
  end

  def create
    @patient = Patient.find(params[:patient_id])
    @treatment = @patient.treatments.build(params[:treatment])
    
    # Law, TODO
    @law = Object.const_get(params[:law][:name]).new
    @law.insured_id = @patient.insurance_nr

    @law.save
    @treatment.law = @law
    
    # TODO make selectable
#    @treatment.canton ||= @tiers.provider.vcard.address.region

    # Services
    @treatment.sessions.build
#    @treatment.diagnoses = medical_cases.map{|medical_case| medical_case.diagnosis}

    # Saving
    if @treatment.save
      flash[:notice] = 'Erfolgreich erstellt.'
      redirect_to @patient, :tab => 'treatments', 'sub-tab' => "treatment-#{@treatment.id}"
    else
      render :action => 'new'
    end
  end
end
