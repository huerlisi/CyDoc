class MailingsController < ApplicationController
  # Authorization
  # =============
  before_filter :authorize, :except => [:list, :index]
  private
  def authorize
    begin
      Mailing.find(params[:id], :conditions => ['doctor_id = ?', @current_doctor.id])
    rescue ActiveRecord::RecordNotFound
      render :text => 'Fall existiert nicht oder Sie haben keine Berechtigung', :status => 404
    end
  end

  # Actions
  # =======
  public
  def index
    redirect_to :action => :list
  end
  
  def overview
    @mailing = Mailing.find(params[:id])
  end

  def list
    @mailings = Mailing.find(:all, :conditions => ['doctor_id = ?', @current_doctor.id])
  end

  def statistics
  end
end
