class AttachmentsController < AuthorizedController
  belongs_to :invoice, :polymorphic => true, :optional => true
  belongs_to :employee, :polymorphic => true, :optional => true
  belongs_to :person, :polymorphic => true, :optional => true
  belongs_to :tenant, :polymorphic => true, :optional => true
  belongs_to :case, :polymorphic => true, :optional => true

  def create
    create! {
      redirect_to :back
      return
    }
  end

  def download
    @attachment = Attachment.find(params[:id])

    path = @attachment.file.current_path
    if @attachment.visible_filename
      send_file path, :filename => @attachment.visible_filename
    else
      send_file path
    end
  end
end
