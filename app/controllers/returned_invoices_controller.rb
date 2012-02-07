class ReturnedInvoicesController < ApplicationController
  # Inherited Resources
  inherit_resources

  protected
    def collection
      instance_eval("@#{controller_name.pluralize} ||= end_of_association_chain.paginate(:page => params[:page], :per_page => params[:per_page], :order => 'created_at DESC')")
    end

  # Scopes
  has_scope :by_doctor_id

  public
  def index
    @returned_invoices = apply_scopes(ReturnedInvoice).open.paginate(:page => params[:page], :per_page => params[:per_page], :order => 'created_at DESC')
  end

  def create
    create! do |success, failure|
      success.html {
        @returned_invoice.patient.update_attribute(:dunning_stop, true)
        flash[:notice] = @returned_invoice.to_s
        redirect_to new_returned_invoice_path
      }
    end
  end

  def update
    @returned_invoice = ReturnedInvoice.find(params[:id])

    @patient = @returned_invoice.patient
    unless @patient.update_attributes(params[:patient])
      render 'patient_form' and return
    end

    case params[:commit]
    when 'queue_request'
      @returned_invoice.queue_request!
    when 'reactivate'
      @returned_invoice.invoice.reactivate.save
      @returned_invoice.reactivate!
    when 'write_off'
      @returned_invoice.invoice.write_off.save
      @returned_invoice.write_off!
    else
    end

    queue = params[:queue]
    if queue.present?
      redirect_to :action => "edit_#{queue}"
    else
      redirect_to returned_invoices_path
    end
  end

  def edit_ready
    @returned_invoice = ReturnedInvoice.ready.first
    if @returned_invoice.nil?
      redirect_to returned_invoices_path and return
    end

    @queue = 'ready'

    render 'edit'
  end

  def reactivate
    @returned_invoice = ReturnedInvoice.find(params[:id])
    @returned_invoice.invoice.reactivate.save
    @returned_invoice.reactivate!

    redirect_to returned_invoices_path
  end

  def write_off
    @returned_invoice = ReturnedInvoice.find(params[:id])
    @returned_invoice.invoice.write_off.save
    @returned_invoice.write_off!

    redirect_to returned_invoices_path
  end

  def queue_request
    @returned_invoice = ReturnedInvoice.find(params[:id])
    @returned_invoice.queue_request!

    redirect_to returned_invoices_path
  end

  def queue_all_requests
    returned_invoices = ReturnedInvoice.by_doctor_id(params[:doctor_id])

    returned_invoices.ready.each do |returned_invoice|
      returned_invoice.queue_request!
    end

    redirect_to returned_invoices_path
  end
end
