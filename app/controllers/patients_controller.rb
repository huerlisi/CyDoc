# -*- encoding : utf-8 -*-

require 'swissmatch/location/autoload'

class PatientsController < AuthorizedController
  # Covercard
  # =========

  # Checks if the patient has new covercard infomations.
  # Returns a flash message when new infomations available.
  def covercard_check_update
    # TODO: Implement an AJAX Request when a patient is loaded to do this action and of course this action.
    @patient = Patient.find(params[:id])
  end

  def covercard_update
    @patient = Patient.find(params[:id])
    @covercard_patient = Covercard::Patient.find(params[:covercard_code])
    @patient, @updated_attributes, @updated_insurance_policies = @covercard_patient.update(@patient)
  end

  def covercard_search
    @covercard_patient = Covercard::Patient.find(params[:code])

    if @covercard_patient
      # TODO .by_name is broken
      @exact_patients = Patient.by_date(@covercard_patient.birth_date).by_name(@covercard_patient.name)
      @date_patients = Patient.by_date(@covercard_patient.birth_date)
      @name_patients = Patient.by_name(@covercard_patient.name)
    end
  end

  def index
    @patients = Patient.by_text params[:query], :star => true, :retry_stale => true, :per_page => 50
  end

  def dunning_stopped
    @patients = Patient.dunning_stopped.all
  end

  def new
    # Use default sex from doctor settings
    case Doctor.settings['patients.sex']
      when 'M'
        resource.sex = 'M'
        resource.vcard.honorific_prefix = 'Herr'
      when 'F'
        resource.sex = 'F'
        resource.vcard.honorific_prefix = 'Frau'
    end

    resource.doctor_patient_nr = Patient.maximum('CAST(doctor_patient_nr AS UNSIGNED INTEGER)').to_i + 1
  end

  # GET /patients/1/show_tab
  def show_tab
    respond_to do |format|
      @patient = Patient.find(params[:id])

      format.js {
        # For partial updates used in form cancellation events
        if tab = params[:tab]
          render :update do |page|
            page.replace "patient-#{tab}", :partial => tab
          end
        end
      }
    end
  end

  # POST /patients/1/print_label
  def label
    @patient = Patient.find(params[:id])

    respond_to do |format|
      format.html {}
      format.pdf { render_pdf(:media => 'Label') }
    end
  end

  # POST /patients/1/print_full_label
  def full_label
    @patient = Patient.find(params[:id])

    respond_to do |format|
      format.html {}
      format.pdf { render_pdf(:media => 'Label') }
    end
  end
end
