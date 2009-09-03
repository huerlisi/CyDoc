require 'action_controller/test_process.rb'

class EsrBookingsController < ApplicationController
  def index
    @esr_files = EsrFile.paginate(:page => params['page'], :per_page => 20, :order => 'updated_at DESC')
    
    respond_to do |format|
      format.html {
        render :action => 'list'
      }
    end
  end

  def create
    vesr_path = params[:filename]
    
    @esr_file = EsrFile.new(:uploaded_data => ActionController::TestUploadedFile.new(vesr_path))
    if @esr_file.save
      # Delete file if saved as attachment
      File.delete(vesr_path)
    end
    
    respond_to do |format|
      format.html {
        redirect_to :action => 'show', :id => @esr_file
      }
      format.js { }
    end
  end

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
