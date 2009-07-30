class SessionsController < ApplicationController
  in_place_edit_for :session, :date

  # GET /sessions/new
  def new
    @patient = Patient.find(params[:patient_id])
    @treatment = Treatment.find(params[:treatment_id])
    
    @session = @treatment.sessions.create(:duration_from => DateTime.now)

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'session_list', :partial => 'list', :object => @treatment.sessions
        end
      }
    end
  end
end
