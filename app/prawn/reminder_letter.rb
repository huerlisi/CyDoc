# -*- encoding : utf-8 -*-
class ReminderLetter < PatientLetter
  # Title
  def title(invoice)
    font_size 16
    text "Patientenrechnung Nr. #{invoice.id}", :style => :bold
  end

  def first_reminder_text(invoice)
    font_size 12
    text "1. Mahnung", :style => :bold
    text " "

    font_size 7.5

    greeting(invoice.patient)

    text "Bei der Durchsicht meiner Buchhaltung habe ich festgestellt, dass die Zahlung der oben erwähnten Rechnung noch nicht verbucht ist. Falls Sie per E-Banking bezahlt haben, bitte ich Sie nochmals zu überpürfen, ob Sie die korrekte Konto- und Referenznummer angegeben haben."
    text " "
    text "- Wenn Sie tatsächlich noch nicht bezahlt haben, möchte ich Sie bitten, den Betrag in den nächsten Tagen zu überweisen."
    text "- Sollte sich Ihre Zahlung mit der Mahnung kreuzen, betrachten Sie dieses Schreiben als gegenstandslos."
    text "- Wir möchten Sie darauf aufmerksam machen, dass die nächste Mahnung gebührenpflichtig ist."
    text " "
  end

  def second_reminder_text(invoice)
    font_size 12
    text "2. Mahnung", :style => :bold
    text " "

    font_size 7.5

    greeting(invoice.patient)

    text "Bei der Durchsicht meiner Buchhaltung habe ich festgestellt, dass die oben erwähnte Rechnung trotz Mahnung noch nicht beglichen ist."
    text " "
    text "- Ich möchte Sie bitten, den Betrag sofort zu überweisen. Andernfalls werden wird unsere Forderung dem Inkasso zu übergeben."
    text "- Sollte sich Ihre Zahlung mit der Mahnung kreuzen, betrachten Sie dieses Schreiben als gegenstandslos."
    text "- Für die Bezahlung benützen Sie unbedingt den beiligenden Einzahlungschein."
    text " "
  end

  def third_reminder_text(invoice)
    font_size 12
    text "3. Mahnung", :style => :bold
    text " "

    font_size 7.5

    greeting(invoice.patient)

    text "Bei der Durchsicht meiner Buchhaltung habe ich festgestellt, dass die oben erwähnte Rechnung trotz Mahnungen nicht beglichen ist."
    text " "
    text "- Überweisen Sie den Betrag unverzüglich. Andernfalls wird die Betreibung eingeleitet."
    text "- Durch eine Betreibung werden für Sie Zusatzkosten bis zu CHF 300.- entstehen."
    text "- Für die Bezahlung benützen Sie unbedingt den beiligenden Einzahlungschein."
    text " "
  end

  def encashment_text(invoice)
    font_size 12
    text "Inkasso", :style => :bold
    text " "

    font_size 7.5
  end

  def invoice_dates(invoice)
    font_size 6.5
    text "Mahndatum:"
    font_size 8
    text invoice.latest_reminder_value_date.to_s
    move_down 3
    font_size 6.5
    text "Zahlbar bis:"
    font_size 8
    text invoice.due_date.to_s
  end

  def greeting(patient)
    text patient.vcard.salutation
    text " "
  end

  def closing(sender)
    if sender.vcard.contacts.email.empty?
      text "Bei allfälligen Unstimmigkeiten rufen Sie uns bitte an."
    else
      text "Bei allfälligen Unstimmigkeiten rufen Sie uns bitte an oder schreiben Sie eine E-Mail an #{sender.vcard.contacts.email.first.number}."
    end
    common_closing(sender)
  end

  def to_pdf(invoice, params = {})
    bounding_box [1.cm, bounds.top], :width => bounds.width do
      title(invoice)

      # Head info
      bounding_box [0, bounds.top - 2.4.cm], :width => 7.cm do
        biller(invoice)
      end

      bounding_box [0, bounds.top - 7.cm], :width => 7.cm do
        referrer(invoice) if invoice.referrer
      end

      billing_address(invoice.biller.user.tenant.person, invoice.billing_vcard)

      bounding_box [12.cm, bounds.top - 8.cm], :width => 7.cm do
        patient(invoice)
      end

      # Text
      bounding_box [0, bounds.top - 9.cm], :width => bounds.width - 3.cm do
        case invoice.state
          when 'reminded'
            first_reminder_text(invoice)
          when '2xreminded'
            second_reminder_text(invoice)
          when '3xreminded'
            third_reminder_text(invoice)
          when 'encashment'
            encashment_text(invoice)
        end

        closing(invoice.biller)
      end

      # Invoice balance
      bounding_box [0, bounds.top - 16.cm], :width => 7.cm do
        balance(invoice)
      end
    end

    # VESR form
    draw_esr(invoice, invoice.biller.esr_account, invoice.biller, invoice.biller.print_payment_for?)

    render
  end
end
