class InvoicesController < ApplicationController
  def tarmed_rueckforderungsbeleg
    @invoice = Invoice.find(params[:id])
  end

  def tarmed
    @invoice = Invoice.find(params[:id])
  end
end
