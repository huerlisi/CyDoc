require 'action_controller/test_process.rb'

class EsrBookingsController < ApplicationController
  # GET /esr_bookings
  def index
    @esr_files = EsrFile.paginate(:page => params['page'], :per_page => 20, :order => 'updated_at DESC')
    
    respond_to do |format|
      format.html {
        render :action => 'list'
      }
    end
  end

  # GET /esr_bookings/new
  def new
    @esr_file = EsrFile.new

    respond_to do |format|
      format.html {
        render :partial => 'form', :layout => 'application'
      }
      format.js { }
    end
  end

  # POST /esr_bookings
  def create
    # if :filename param is set, file exists
    if params[:filename]
      vesr_path = params[:filename]
      
      @esr_file = EsrFile.new(:uploaded_data => ActionController::TestUploadedFile.new(vesr_path))
    else
      @esr_file = EsrFile.new(params[:esr_file])
    end

    if @esr_file.save
      # Delete file if saved as attachment
      File.delete(vesr_path) if vesr_path
    end
    
    respond_to do |format|
      format.html {
        redirect_to :action => 'show', :id => @esr_file
      }
      format.js { }
    end
  end

  # GET /esr_bookings/1
  def show
    @esr_file = EsrFile.find(params[:id])
    
    respond_to do |format|
      format.html {
        render :action => 'show'
      }
      format.js { }
    end
  end
end
