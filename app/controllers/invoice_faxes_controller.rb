class InvoiceFaxesController < ApplicationController
  before_filter do |controller|
    @invoice = Invoice.find(controller.params[:invoice_id]) if controller.params[:invoice_id]
  end

  def create
    @invoice = Invoice.find(params[:invoice_id]) if params[:invoice_id]
    number = params[:fax][:number]

    
    filename = Rails.root.join('system', 'fax_queue', "#{number}_cydoc-invoice_#{@invoice.id}.pdf")

    invoice_file = File.new('cydoc-invoice.pdf', 'w')
    invoice_file.binmode
    invoice_file.write @invoice.document_to_pdf(:patient_letter)
    invoice_file.close
    
    insurance_file = File.new('cydoc-insurance.pdf', 'w')
    insurance_file.binmode
    insurance_file.write @invoice.document_to_pdf(:insurance_recipe)
    insurance_file.close

    system 'pdftk', invoice_file.path, insurance_file.path, 'cat', 'output', filename
  end
end
