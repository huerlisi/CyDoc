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
          page.replace_html "treatment_#{@treatment.id}_session_list", :partial => 'list', :object => @treatment.sessions
        end
      }
    end
  end

  # DELETE /sessions/1
  def destroy
    @session = Session.find(params[:id])
    @treatment = @session.treatment

    @session.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "session_#{@session.id}"
          page.replace_html "treatment_#{@treatment.id}_service_list_total", "Total: #{@treatment.amount.currency_round}"
        end
      }
    end
  end
end
