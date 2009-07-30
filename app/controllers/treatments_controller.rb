class TreatmentsController < ApplicationController
  def show
    @treatment = Treatment.find(params[:id])
    
    redirect_to :controller => :patients, :action => :show, :id => @treatment.patient_id, :tab => 'treatments', :sub_tab => "treatments_#{@treatment.id}"
  end

  def edit
    @treatment = Treatment.find(params[:id])

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.call 'showSubTab', "treatments-#{@treatment.id}", 'treatments'
          page.replace "treatment-#{@treatment.id}", :partial => 'form'
        end
      }
    end
  end

  def new
    @treatment = Treatment.new
    @treatment.date_begin = Date.today
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.insert_html :after, 'new-sub-tab-content-treatments', :partial => 'edit'
          page.select('.sub-tab-treatments .sub-tab-content').each do |tab|
            tab.hide
          end
          page.call 'showTab', 'treatments'
        end
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
    @treatment.sessions.build(:duration_from => @treatment.date_begin)
#    @treatment.diagnoses = medical_cases.map{|medical_case| medical_case.diagnosis}

    # Saving
    if @treatment.save
      flash[:notice] = 'Erfolgreich erstellt.'
      redirect_to @treatment
    else
      render :action => 'new'
    end
  end

  def update
    @treatment = Treatment.find(params[:id])

    # Saving
    if @treatment.update_attributes(params[:treatment])
      flash[:notice] = 'Erfolgreich erstellt.'
      redirect_to @treatment
    else
      render :action => ''
    end
  end
end
