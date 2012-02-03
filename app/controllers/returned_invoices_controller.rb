class ReturnedInvoicesController < ApplicationController
  inherit_resources
  # Inherited Resources
  protected
    def collection
      instance_eval("@#{controller_name.pluralize} ||= end_of_association_chain.paginate(:page => params[:page], :per_page => params[:per_page], :order => 'created_at DESC')")
    end

  public
  def index
    @returned_invoices = ReturnedInvoice.open.paginate(:page => params[:page], :per_page => params[:per_page], :order => 'created_at DESC')
  end

  def create
    create! { new_returned_invoice_path }
  end

  def resolve
    @returned_invoice = ReturnedInvoice.find(params[:id])
    @returned_invoice.resolve!

    redirect_to returned_invoices_path
  end

  def queue_request
    @returned_invoice = ReturnedInvoice.find(params[:id])
    @returned_invoice.queue_request!

    redirect_to returned_invoices_path
  end

  def queue_all_requests
    @doctor = Doctor.find(params[:doctor_id])

    returned_invoices = ReturnedInvoice.by_doctor(@doctor)

    returned_invoices.ready.each do |returned_invoice|
      returned_invoice.queue_request!
    end

    redirect_to returned_invoices_path
  end
end
