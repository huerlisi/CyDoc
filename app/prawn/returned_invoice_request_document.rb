module Prawn
  class ReturnedInvoiceRequestDocument < Prawn::LetterDocument
    def to_pdf(doctor, params)
      receiver = doctor
      sender = params[:sender]

      # Header
      letter_header(sender, receiver, doctor.to_s)

      # Closing
      common_closing(sender)

      # Footer
      render
    end
  end
end
