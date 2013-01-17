# -*- encoding : utf-8 -*-

class ReturnedInvoiceRequestDocument < LetterDocument
  def to_pdf(doctor, params)
    receiver = doctor
    sender = params[:sender]

    # Header
    letter_header(sender, receiver, "Adresskorrekturen")

    free_text(
      "Rechnungen an folgende Patientinnen konnten von der Post nicht zugestellt werden.

      Dürfen wir Sie bitten, die Adressen mit ihrer Patientenkartei zu überprüfen. Wir wären froh, wenn sie die Adressen allenfalls korrigieren und uns dieses Blatt zurückfaxen würden."
    )
    text " "

    # Invoice list
    new_returned_invoices = doctor.returned_invoices.ready
    if new_returned_invoices.present?
      invoices_table(new_returned_invoices)
      text " "
    end

    pending_returned_invoices = doctor.returned_invoices.request_pending
    if pending_returned_invoices.present?
      text "Ausstehende Anfragen", :style => :bold
      invoices_table(pending_returned_invoices)
      text " "
    end

    # Closing
    common_closing(sender)

    # Footer
    render
  end

  def invoices_table(returned_invoices)
    content = [[
      t_attr(:doctor_patient_nr, Patient),
      t_attr(:full_name, Vcard),
      t_attr(:street_address, Vcard),
      [t_attr(:postal_code, Vcard), t_attr(:locality, Vcard)].join("/")
    ]]

    rows = returned_invoices.inject(content) {|content, invoice|
      patient = invoice.patient
      vcard = patient.vcard
      content << [
        patient.doctor_patient_nr,
        vcard.full_name,
        vcard.street_address,
        [vcard.postal_code, vcard.locality].compact.join(' ')
      ]
      if patient.use_billing_address?
        vcard = patient.billing_vcard
        content << [
          "Rechnungsadresse",
          [vcard.full_name, vcard.extended_address, vcard.post_office_box].select{|field| field.present?}.join(" / "),
          vcard.street_address,
          [vcard.postal_code, vcard.locality].compact.join(' ')
        ]
      end

      content << [" ", nil, nil, nil]
      content
    }

    table rows, :width => 17.cm do
      # General
      cells.borders = []
      cells.padding = [0.5, 2, 1, 2]

      column(0).padding_left = 0
      column(-1).padding_right = 0

      row(0).font_style = :bold
    end
  end
end
