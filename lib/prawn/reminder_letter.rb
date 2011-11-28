require 'prawn/measurement_extensions'

module Prawn
  class ReminderLetter < PatientLetter
    # Title
    def title(invoice)
      font "DejaVuSans"
      font_size 16
      text "Patientenrechnung Nr. #{invoice.id}", :style => :bold
    end

    def first_reminder_text(invoice)
      font_size 12
      text "1. Mahnung", :style => :bold
      text " "

      font_size 7.5

      text "Sehr geehrte Patientin,"
      text " "
      text "Bei der Durchsicht meiner Buchhaltung habe ich festgestellt, dass die Zahlung der oben erwähnten Rechnung noch nicht verbucht ist. Falls Sie per E-Banking bezahlt haben, bitte ich Sie nochmals zu überpürfen, ob Sie die korrekte Konto- und Referenznummer angegeben haben."
      text " "
      text "- Wenn Sie tatsächlich noch nicht bezahlt haben, möchte ich Sie bitten, den Betrag in den nächsten Tagen zu überweisen."
      text "- Sollte sich Ihre Zahlung mit der Mahnung kreuzen, betrachten Sie dieses Schreiben als gegenstandslos."
      text "- Wir möchten Sie darauf aufmerksam machen, dass die nächste Mahnung gebührenpflichtig ist."
      text " "
      text "Bei allfälligen Unstimmigkeiten rufen Sie uns bitte an oder schreiben Sie eine E-Mail an admin@zyto-labor.com."
      text " "
      text "Mit freundlichen Grüssen"
      text "ZytoLabor"
    end

    def second_reminder_text(invoice)
      font_size 12
      text "2. Mahnung", :style => :bold
      text " "

      font_size 7.5

      text "Sehr geehrte Patientin,"
      text " "
      text "Bei der Durchsicht meiner Buchhaltung habe ich festgestellt, dass die oben erwähnte Rechnung trotz Mahnung noch nicht beglichen ist."
      text " "
      text "- Ich möchte Sie bitten, den Betrag sofort zu überweisen. Andernfalls werden wird unsere Forderung dem Inkasso zu übergeben."
      text "- Sollte sich Ihre Zahlung mit der Mahnung kreuzen, betrachten Sie dieses Schreiben als gegenstandslos."
      text "- Für die Bezahlung benützen Sie unbedingt den beiligenden Einzahlungschein."
      text " "
      text "Bei allfälligen Unstimmigkeiten rufen Sie uns bitte an oder schreiben Sie eine E-Mail an admin@zyto-labor.com."
      text " "
      text "Mit freundlichen Grüssen"
      text "ZytoLabor"
    end

    def third_reminder_text(invoice)
      font_size 12
      text "3. Mahnung", :style => :bold
      text " "

      font_size 7.5

      text "Sehr geehrte Patientin,"
      text " "
      text "Bei der Durchsicht meiner Buchhaltung habe ich festgestellt, dass die oben erwähnte Rechnung trotz Mahnungen nicht beglichen ist."
      text " "
      text "- Überweisen Sie den Betrag unverzüglich. Andernfalls wird die Betreibung eingeleitet."
      text "- Durch eine Betreibung werden für Sie Zusatzkosten bis zu CHF 300.- entstehen."
      text "- Für die Bezahlung benützen Sie unbedingt den beiligenden Einzahlungschein."
      text " "
      text "Bei allfälligen Unstimmigkeiten rufen Sie uns bitte an oder schreiben Sie eine E-Mail an admin@zyto-labor.com."
      text " "
      text "Mit freundlichen Grüssen"
      text "ZytoLabor"
    end

    def encashment_text(invoice)
      font_size 12
      text "Inkasso", :style => :bold
      text " "

      font_size 7.5
    end

    def to_pdf(invoice)
      set_fonts
   
      bounding_box [1.cm, bounds.top], :width => bounds.width do
        title(invoice)

        # Head info
        bounding_box [0, bounds.top - 2.4.cm], :width => 7.cm do
          biller(invoice)

          text " "
          font_size 6.5
          text "Mahndatum:"
          font_size 8
          text invoice.latest_reminder_value_date.to_s
        end

        bounding_box [0, bounds.top - 6.cm], :width => 7.cm do
          referrer(invoice)
        end

        bounding_box [12.cm, bounds.top - 3.5.cm], :width => 7.cm do
          billing_address(invoice)
        end

        bounding_box [12.cm, bounds.top - 6.cm], :width => 7.cm do
          patient(invoice)
        end

        # Text
        bounding_box [0, bounds.top - 9.cm], :width => bounds.width - 3.cm do
          case invoice.state
            when 'reminded':
              first_reminder_text(invoice)
            when '2xreminded':
              second_reminder_text(invoice)
            when '3xreminded':
              third_reminder_text(invoice)
            when 'encashment':
              encashment_text(invoice)
          end
        end

        # Invoice balance
        bounding_box [0, bounds.top - 15.cm], :width => 7.cm do
          balance(invoice)
        end
      end

      # VESR form
      vesr(invoice)
    end
  end
end
