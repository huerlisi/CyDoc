# -*- encoding : utf-8 -*-
class TreatmentsController < AuthorizedController
  has_scope :by_state

  def new
    @treatment = Treatment.new(params[:treatment])
    @treatment.date_begin ||= Date.today

    # Build associated Law object
    @treatment.build_law
  end

  # PUT /patients/1/treatment
  def create
    @patient = Patient.find(params[:patient_id])
    @treatment = @patient.treatments.build(params[:treatment])

    # Law
    law = @treatment.law
    # TODO: don't just pick first one
    insurance_policy = @patient.insurance_policies.by_policy_type(law.name).first
    law.insured_id = insurance_policy.number unless insurance_policy.nil?

    # TODO make selectable
#    @treatment.canton ||= @tiers.provider.vcard.address.region

    # Services
    @treatment.sessions.build(:duration_from => @treatment.date_begin)
#    @treatment.diagnoses = medical_cases.map{|medical_case| medical_case.diagnosis}

    create!
  end

  def destroy
    destroy! { @treatment.patient }
  end
end
