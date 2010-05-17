class RecallsController < ApplicationController
  # Filter
  has_scope :by_period, :using => [:from, :to]

  # GET /recalls
  def index
    @recalls = apply_scopes(Recall).open.paginate(:page => params['page'], :order => 'due_date')
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
    # @recall.appointment.patient = @recall.patient
    # @recall.appointment.state = 'proposed'
    
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
    @patient = Patient.find(params[:patient_id]) if params[:patient_id]
    @recall = Recall.find(params[:id])
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.insert_html :after, "recall_#{@recall.id}", :partial => 'recalls/form'
        end
      }
    end
  end
  
  # PUT /recall/1
  # PUT /patients/1/recall/2
  def update
    @patient = Patient.find(params[:patient_id]) if params[:patient_id]
    @recall = Recall.find(params[:id])
    
    if @recall.update_attributes(params[:recall])
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            if @patient
              # reload all recalls when called in patient view to reflect sorting
              page.replace_html 'recalls', :partial => 'recalls/patient_item', :collection => @patient.recalls.open
            else
              page.replace "recall_#{@recall.id}", :partial => 'item', :object => @recall
              page.remove "recall_form"
            end
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace 'recall_form', :partial => 'recalls/form'
          end
        }
      end
    end
  end

  # POST /recall/1/prepare
  def prepare
    @recall = Recall.find(params[:id])
    @recall.prepare
    
    unless @recall.appointment
      @recall.build_appointment(:patient => @recall.patient)
    end

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.insert_html :after, "recall_#{@recall.id}", :partial => 'recalls/form'
        end
      }
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
