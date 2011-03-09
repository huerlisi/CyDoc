class TreatmentsController < ApplicationController
  in_place_edit_for :session, :date
  # TODO: is duplicated in ServiceRecordsController
  in_place_edit_for :service_record, :ref_code
  in_place_edit_for :service_record, :quantity

  # GET /treatments/1
  # GET /patients/1/treatments/2
  def show
    @treatment = Treatment.find(params[:id])
    
    respond_to do |format|
      format.html {
        redirect_to :controller => :patients, :action => :show, :id => @treatment.patient_id, :tab => 'treatments', :sub_tab_id => @treatment.id
      }
      format.js {
        render :update do |page|
          page.replace_html "tab-content-treatments", :partial => 'show'
          page.call 'showTab', controller_name
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
          page.replace_html "treatment", :partial => 'form'
          page.call(:initBehaviour)
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
          page.replace_html 'tab-content-treatments', :partial => 'new'
          page.call 'showTab', controller_name
          page.call(:initBehaviour)
        end
      }
    end
  end

  # PUT /patients/1/treatment
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
      respond_to do |format|
        format.html {
          redirect_to @treatment
        }
        format.js {
          render :update do |page|
            page.redirect_to @treatment
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace_html "treatment", :partial => 'form'
            page.call(:initBehaviour)
          end
        }
      end
    end
  end

  # PUT /treatment/1
  def update
    @treatment = Treatment.find(params[:id])

    # Saving
    if @treatment.update_attributes(params[:treatment])
      flash[:notice] = 'Erfolgreich erstellt.'
      respond_to do |format|
        format.html { 
          redirect_to @treatment
        }
        format.js {
          render :update do |page|
            page.replace_html "tab-content-treatments", :partial => 'show'
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace_html 'treatment', :partial => 'form'
            page.call(:initBehaviour)
          end
        }
      end
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
