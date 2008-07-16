class MailingsController < ApplicationController
  # Authorization
  # =============
  before_filter :authorize, :except => [:list, :index, :latest_overview]
  private
  def authorize
    begin
      Mailing.find(params[:id], :conditions => ['doctor_id = ?', @current_doctor.id])
    rescue ActiveRecord::RecordNotFound
      render :partial => 'shared/access_denied', :layout => 'cases', :status => 404
    end
  end

  # Actions
  # =======
  public
  def index
    redirect_to :action => :latest_overview
  end
  
  def latest_overview
    @mailing = Mailing.find(:first, :order => 'printed_at desc', :conditions => ['doctor_id = ?', @current_doctor.id])
    render :action => 'overview', :layout => 'cases'
  end

  def overview
    @mailing = Mailing.find(params[:id])
  end

  def overview_inline
    overview
    render :action => 'overview', :layout => false
  end

  def list
    @mailings = Mailing.find(:all, :conditions => ['doctor_id = ?', @current_doctor.id])
    render :layout => 'cases'
  end

  def statistics
  end
end
