# -*- encoding : utf-8 -*-
class SessionsController < AuthorizedController
  # GET /sessions/new
  def new
    @patient = Patient.find(params[:patient_id])
    @treatment = Treatment.find(params[:treatment_id])

    @treatment.sessions.create(:duration_from => DateTime.now)

    new!
  end
end
