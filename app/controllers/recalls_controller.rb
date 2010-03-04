class RecallsController < ApplicationController
  # GET /recalls/new
  def new
    @patient = Patient.find(params[:patient_id])
    
    @recall = @patient.recalls.build

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "new_recall", :partial => 'form'
        end
      }
    end
  end
end
