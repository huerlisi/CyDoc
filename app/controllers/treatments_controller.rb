class TreatmentsController < ApplicationController
  # GET /treatments/1
  # GET /patients/1/treatments/2
  def show
    @treatment = Treatment.find(params[:id])
    
    respond_to do |format|
      format.html {
        redirect_to :controller => :patients, :action => :show, :id => @treatment.patient_id, :tab => 'treatments', :sub_tab => "treatments_#{@treatment.id}"
      }
      format.js {
        render :update do |page|
          page.replace_html "tab-content-treatments", :partial => 'show'
        end
      }
    end
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
    
    # Law
    @law = Object.const_get(params[:law][:name]).new
    # TODO: don't just pick first one
    insurance_policy = @patient.insurance_policies.by_policy_type(@law.name).first
    @law.insured_id = insurance_policy.number unless insurance_policy.nil?

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

  def destroy
    @treatment = Treatment.find(params[:id])
    @patient = @treatment.patient
    
    @treatment.destroy
    
    respond_to do |format|
      format.html {
        redirect_to @patient
      }
      format.js {
        render :update do |page|
          page.redirect_to @patient
        end
      }
    end
  end
end
