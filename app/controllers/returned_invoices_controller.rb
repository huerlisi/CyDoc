class ReturnedInvoicesController < ApplicationController
  inherit_resources
  # Inherited Resources
  protected
    def collection
      instance_eval("@#{controller_name.pluralize} ||= end_of_association_chain.paginate(:page => params[:page], :per_page => params[:per_page], :order => 'created_at DESC')")
    end

  public
  def create
    create! { new_returned_invoice_path }
  end
end
