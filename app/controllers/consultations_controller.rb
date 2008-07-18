class ConsultationsController < ApplicationController
  # GET /consultations
  # GET /consultations.xml
  def index
    @consultations = Consultation.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultations }
    end
  end

  # GET /consultations/1
  # GET /consultations/1.xml
  def show
    @consultation = Consultation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consultation }
    end
  end

  # GET /consultations/new
  # GET /consultations/new.xml
  def new
    @consultation = Consultation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consultation }
    end
  end

  # GET /consultations/1/edit
  def edit
    @consultation = Consultation.find(params[:id])
  end

  # POST /consultations
  # POST /consultations.xml
  def create
    @consultation = Consultation.new(params[:consultation])

    respond_to do |format|
      if @consultation.save
        flash[:notice] = 'Consultation was successfully created.'
        format.html { redirect_to(@consultation) }
        format.xml  { render :xml => @consultation, :status => :created, :location => @consultation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @consultation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /consultations/1
  # PUT /consultations/1.xml
  def update
    @consultation = Consultation.find(params[:id])

    respond_to do |format|
      if @consultation.update_attributes(params[:consultation])
        flash[:notice] = 'Consultation was successfully updated.'
        format.html { redirect_to(@consultation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consultation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /consultations/1
  # DELETE /consultations/1.xml
  def destroy
    @consultation = Consultation.find(params[:id])
    @consultation.destroy

    respond_to do |format|
      format.html { redirect_to(consultations_url) }
      format.xml  { head :ok }
    end
  end
end
