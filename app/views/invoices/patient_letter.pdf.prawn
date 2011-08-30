# Helpers
def draw_address(pdf, vcard)
  pdf.text vcard.full_name
  pdf.text vcard.extended_address if vcard.extended_address.present?
  pdf.text vcard.street_address
  pdf.text vcard.postal_code + " " + vcard.locality
end

# Fonts
font_path = '/usr/share/fonts/truetype/ttf-dejavu/'
pdf.font_families.update(
  "DejaVuSans" => { :bold        => font_path + "DejaVuSans-Bold.ttf",
                    :normal      => font_path + "DejaVuSans.ttf"
  })

# Title
pdf.bounding_box [1.cm, pdf.bounds.top], :width => pdf.bounds.width do
  pdf.font "DejaVuSans"
  pdf.font_size 16
  pdf.text "Patientenrechnung Nr. #{@invoice.id}", :style => :bold
  pdf.font_size 6.5
  pdf.text "Diese Seite ist für Ihre Unterlagen, der beilegende Rückforderungsbeleg für Ihre Krankenkasse."

  # Biller / Provider
  pdf.bounding_box [0, pdf.bounds.top - 2.4.cm], :width => 7.cm do
    pdf.font_size 6.5
    pdf.text "Rechnungssteller/Leistungserbringer:"
    pdf.font_size 8
    draw_address(pdf, @invoice.biller.vcard)
    for contact in @invoice.biller.vcard.contacts
      pdf.text contact.to_s
    end
    pdf.text " "
    pdf.font_size 6.5
    pdf.text "Rechnungs-Datum:"
    pdf.font_size 8
    pdf.text @invoice.value_date.to_s
  end

  # Referrer
  pdf.bounding_box [0, pdf.bounds.top - 8.cm], :width => 7.cm do
    pdf.font_size 6.5
    pdf.text "Zuweisender Arzt:"
    pdf.font_size 8
    draw_address(pdf, @invoice.referrer.vcard)
    pdf.text " "
    pdf.font_size 6.5
    pdf.text "Behandlung vom:"
    pdf.font_size 8
    pdf.text @invoice.treatment.date_begin.to_s
  end

  # Billing Address
  pdf.bounding_box [12.cm, pdf.bounds.top - 3.5.cm], :width => 7.cm do
    pdf.font_size 10
    pdf.text @invoice.patient.honorific_prefix
    draw_address(pdf, @invoice.patient.vcard)
  end

  # Patient
  pdf.bounding_box [12.cm, pdf.bounds.top - 8.cm], :width => 7.cm do
    pdf.font_size 6.5
    pdf.text "Patient:"
    pdf.font_size 8
    draw_address(pdf, @invoice.patient.vcard)
    pdf.text " "
    pdf.font_size 6.5
    pdf.text "Geburtsdatum:"
    pdf.font_size 8
    pdf.text @invoice.patient.birth_date.to_s
  end

  # Invoice balance
  pdf.bounding_box [0, pdf.bounds.top - 13.cm], :width => 7.cm do
    pdf.font_size 6.5
    pdf.text "Rechnungsdaten:"
    pdf.font_size 8
    content = @invoice.bookings.map{|booking|
      [
        booking.value_date,
        booking.title + (booking.comments.present? ? "\n<font size='6.5'>#{booking.comments}</font>" : ""),
        sprintf("%0.2f CHF", booking.accounted_amount(Invoice::DEBIT_ACCOUNT))
      ]
    }
    content << [
      nil,
      @invoice.due_amount.currency_round >= 0 ? t_attr(:open_amount, Invoice) : t_attr(:balance, Invoice),
      sprintf("%0.2f CHF", @invoice.due_amount.currency_round)
    ]

    pdf.table content, :width => 13.cm, :cell_style => {:inline_format => true} do
      # General
      cells.borders = []
      cells.padding = [0.5, 2, 0.5, 2]

      # With
      column(0).width = 3.cm
      column(1).width = 8.cm
      column(2).width = 2.cm

      # Alignment
      column(2).align = :right

      # Total
      row(-1).borders    = [:top]
      row(-1).font_style = :bold
    end
  end
end


# VESR form
# =========
bank_account = @invoice.biller.esr_account
bank = bank_account.bank
amount = (@invoice.state == 'booked') ? @invoice.due_amount.currency_round : @invoice.amount.currency_round

pdf.font_size 8
pdf.bounding_box [0.2.cm, 8.8.cm], :width => 5.cm do
  pdf.text bank.vcard.full_name
  pdf.text bank.vcard.postal_code + " " + bank.vcard.locality

  pdf.text " "
  pdf.text t_attr(:biller)
  pdf.text " "

  vcard = bank_account.holder.vcard
  pdf.text vcard.full_name
  pdf.text vcard.extended_address if vcard.extended_address.present?
  pdf.text vcard.street_address
  pdf.text vcard.postal_code + " " + vcard.locality

  pdf.move_down 0.7.cm
  pdf.indent 2.3.cm do
    pdf.font_size 9 do
      pdf.text bank_account.pc_id
    end
  end
end
  
pdf.bounding_box [0, 4.5.cm], :width => 3.5.cm do
  pdf.font_size 9 do
    pdf.text sprintf('%.0f', amount.floor), :align => :right
  end
end

pdf.bounding_box [4.7.cm, 4.5.cm], :width => 1.cm do
  pdf.font_size 9 do
    pdf.text sprintf('%.0f', amount * 100 % 100)
  end
end

pdf.bounding_box [0.2.cm, 3.2.cm], :width => 5.cm do
  pdf.text @invoice.esr9_reference(bank_account)

  pdf.text " "

  vcard = @invoice.patient.vcard
  pdf.text vcard.full_name
  pdf.text vcard.extended_address if vcard.extended_address.present?
  pdf.text vcard.street_address
  pdf.text vcard.postal_code + " " + vcard.locality
end

pdf.bounding_box [6.cm, 8.8.cm], :width => 5.cm do
  pdf.text bank.vcard.full_name
  pdf.text bank.vcard.postal_code + " " + bank.vcard.locality

  pdf.text " "
  pdf.text t_attr(:biller)
  pdf.text " "

  vcard = bank_account.holder.vcard
  pdf.text vcard.full_name
  pdf.text vcard.extended_address if vcard.extended_address.present?
  pdf.text vcard.street_address
  pdf.text vcard.postal_code + " " + vcard.locality

  pdf.move_down 0.7.cm
  pdf.indent 2.6.cm do
    pdf.font_size 9 do
      pdf.text bank_account.pc_id
    end
  end
end

pdf.bounding_box [6.cm, 4.5.cm], :width => 3.5.cm do
  pdf.font_size 9 do
    pdf.text sprintf('%.0f', amount.floor), :align => :right
  end
end

pdf.bounding_box [10.8.cm, 4.5.cm], :width => 1.cm do
  pdf.font_size 9 do
    pdf.text sprintf('%.0f', amount * 100 % 100)
  end
end

pdf.font_size 10 do
  pdf.draw_text @invoice.esr9_reference(bank_account), :at => [12.3.cm, 5.9.cm]
end

pdf.bounding_box [12.1.cm, 4.5.cm], :width => 7.5.cm do
  vcard = @invoice.patient.vcard
  pdf.text vcard.honorific_prefix
  pdf.text vcard.full_name
  pdf.text vcard.extended_address if vcard.extended_address.present?
  pdf.text vcard.street_address
  pdf.text vcard.postal_code + " " + vcard.locality
end

# ESR-Reference
pdf.font_size 10
pdf.font Rails.root.join('data', 'ocrb10.ttf')
pdf.draw_text @invoice.esr9(@invoice.biller.esr_account), :at => [6.1.cm, 1.cm]
