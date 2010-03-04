class RecallsController < ApplicationController
  # GET /patients/1/recalls/new
  def new
    @patient = Patient.find(params[:patient_id])
    @recall  = @patient.recalls.build

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "new_recall", :partial => 'form'
        end
      }
    end
  end

  # PUT /patients/1/recall
  def create
    @patient = Patient.find(params[:patient_id])
    @recall  = @patient.recalls.build(params[:recall])
    
    if @recall.save
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.insert_html :top, 'recalls', :partial => 'recalls/item', :object => @recall
            page.replace_html 'new_recall'
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace 'recall_form', :partial => 'recalls/form', :object => @recall
          end
        }
      end
    end
  end

  # DELETE /recall/1
  def destroy
    @recall = Recall.find(params[:id])
    @recall.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "recall_#{@recall.id}"
        end
      }
    end
  end
end
