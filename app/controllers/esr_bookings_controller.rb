require 'action_controller/test_process.rb'

class EsrBookingsController < ApplicationController
  VESR_DIR = File.join(RAILS_ROOT, 'data', 'vesr')

  def index
    @esr_files = EsrFile.paginate(:page => params['page'], :per_page => 20, :order => 'updated_at DESC')
    
    respond_to do |format|
      format.html {
        render :action => 'list'
      }
    end
  end

  def create
    # Just pick first file or return
    vesr_filename = Dir.new(VESR_DIR).select{|entry| !(entry.starts_with?('.') or entry.starts_with?('archive'))}.first
    if vesr_filename.nil?
      render :string => '<h3>Keine VESR Datei gefunden</h3>'
      return
    end
    
    vesr_path = File.join(VESR_DIR, vesr_filename)
    @esr_file = EsrFile.new(:uploaded_data => ActionController::TestUploadedFile.new(vesr_path))
    @esr_file.save

    # Move file to archive
    archive_filename = File.join(VESR_DIR, "vesr-#{DateTime.now.strftime('%Y-%m-%d_%H-%M-%S')}.v11")
    File.rename(vesr_path, archive_filename)
    
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
