class InvoicesController < ApplicationController
  def tarmed_rueckforderungsbeleg
    @invoice = Invoice.find(params[:id])
  end

  def tarmed
    @invoice = Invoice.find(params[:id])
  end

  def tarmed_for_pdf
    tarmed
    render :layout => 'simple'
  end

  def tarmed_rueckforderungsbeleg_for_pdf
    tarmed_rueckforderungsbeleg
    render :layout => 'simple'
  end

end
