# encoding: UTF-8

class FaxesController < ApplicationController
  inherit_resources

  belongs_to :case, :optional => true
  has_scope :by_state

  def new
    render 'show_modal'
  end

  def index
    @faxes = apply_scopes(Fax).paginate(:page => params[:page])
  end

  def create
    resource.sender = current_user.object
    if resource.save
      resource.send_fax

      flash.notice = 'An fax gesendet...'
      render 'show_flash'
    else
      render 'replace_form'
    end
  end
end
