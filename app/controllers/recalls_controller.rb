class RecallsController < ApplicationController
  # GET /recalls
  def index
    @recalls = Recall.open.paginate(:page => params['page'], :order => 'due_date')

    render :action => 'list'
  end
  
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
    
    # Should be handled by model
    @recall.appointment.patient = @recall.patient
    @recall.appointment.state = 'proposed'
    
    if @recall.save
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace_html 'recalls', :partial => 'recalls/patient_item', :collection => @patient.recalls.open
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

  # GET /recall/1/edit
  def edit
    @patient = Patient.find(params[:patient_id])
    @recall = Recall.find(params[:id])
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'new_recall', :partial => 'recalls/form'
        end
      }
    end
  end
  
  # PUT /recall/1
  # PUT /patients/1/recall/2
  def update
    @patient = Patient.find(params[:patient_id])
    @recall = Recall.find(params[:id])
    
    if @recall.update_attributes(params[:recall])
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace_html 'recalls', :partial => 'recalls/patient_item', :collection => @patient.recalls.open
            page.replace_html 'new_recall'
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace_html 'recall_form', :partial => 'recalls/form'
          end
        }
      end
    end
  end

  # POST /recall/1/obey
  def obey
    @recall = Recall.find(params[:id])
    @recall.obey
    @recall.save
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "recall_#{@recall.id}"
        end
      }
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

  # GET /patients/1/recalls/1
  def show
    @recall  = Recall.find(params[:id])
    @patient = @recall.patient

    respond_to do |format|
      format.pdf {
        render :layout => false
      }
    end
  end


end
