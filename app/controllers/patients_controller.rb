class PatientsController < ApplicationController

  def show
    @patient = Patient.find(params[:id])
    @vcard = @patient.vcard
    @billing_vcard = @patient.billing_vcard
    @insurance = @patient.insurance
    @doctor = @patient.doctor
  end
end
