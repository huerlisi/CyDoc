# -*- encoding : utf-8 -*-
class SessionsController < AuthorizedController
  in_place_edit_for :session, :date

  # GET /sessions/new
  def new
    @patient = Patient.find(params[:patient_id])
    @treatment = Treatment.find(params[:treatment_id])

    @treatment.sessions.create(:duration_from => DateTime.now)

    new!
  end

  def show
    @session = Session.find(params[:id])
    treatment = @session.treatment

    invoice = treatment.invoices.last

    redirect_to invoice || treatment
  end
end
