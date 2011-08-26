# Helpers


# Address
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
