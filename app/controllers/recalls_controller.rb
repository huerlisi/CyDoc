# -*- encoding : utf-8 -*-
class RecallsController < AuthorizedController
  # Filter
  has_scope :by_period, :using => [:from, :to]

  # GET /recalls
  def index
    @scheduled_recalls = apply_scopes(Recall).queued.page params['page']
    @sent_recalls = apply_scopes(Recall).sent.page params['page']
  end

  # GET /patients/1/recalls/new
  def new
    @patient = Patient.find(params[:patient_id])
    @recall  = @patient.recalls.build(:doctor => current_doctor)

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "new_recall", :partial => 'form'
          page.call(:initBehaviour)
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
            page.replace_html 'patient_recalls', :partial => 'recalls/patient_item', :collection => @patient.recalls.active
            page.remove 'new_recall'
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace 'recall_form', :partial => 'recalls/form', :object => @recall
            page.call(:initBehaviour)
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
          page.call(:initBehaviour)
        end
      }
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

  # POST /recall/1/send
  def send_notice
    @recall = Recall.find(params[:id])
    @recall.send_notice
    @recall.save

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "recall_form"
          page.redirect_to :action => 'show', :format => :pdf
        end
      }
    end
  end

  # POST /recall/1/obey
  def obey
    @recall = Recall.find(params[:id])
    @patient = @recall.patient
    @recall.obey
    @recall.save

    @old_recall = @recall
    @recall = @old_recall.patient.recalls.build
    @recall.remarks = @old_recall.remarks
    last_session = @old_recall.patient.last_session
    next_due_date = last_session.nil? ? Date.today.in(1.year) : last_session.duration_from.in(1.year)
    @recall.due_date = next_due_date.to_date

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.insert_html :after, "recall_#{@old_recall.id}", :partial => 'form'
          page.remove "recall_#{@old_recall.id}"
        end
      }
    end
  end

  # GET /patients/1/recalls/1
  def show
    @recall  = Recall.find(params[:id])
    @patient = @recall.patient

    respond_to do |format|
      format.html
      format.pdf {
        document = @recall.document_to_pdf(:recall_letter)

        send_data document, :filename => "#{@recall.id}.pdf",
                            :type => "application/pdf",
                            :disposition => 'inline'
      }
    end
  end
end
