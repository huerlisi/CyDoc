# -*- encoding : utf-8 -*-
class AttachmentsController < AuthorizedController
  belongs_to :doctor, :polymorphic => true, :optional => true

  def create
    create! {
      redirect_to :back
      return
    }
  end

  def download
    @attachment = Attachment.find(params[:id])

    path = @attachment.file.current_path
    send_file path
  end
end
