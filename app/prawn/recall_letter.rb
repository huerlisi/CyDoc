# -*- encoding : utf-8 -*-

class RecallLetter < LetterDocument
  def greeting(patient)
    text patient.vcard.salutation
    text " "
  end

  def to_pdf(recall, params = {})
    doctor = recall.doctor

    # sender address
    bounding_box([1.7.cm, 25.5.cm], :width => 7.cm) do
      text [doctor.honorific_prefix, doctor.given_name, doctor.family_name].join(' ')
      font "Helvetica", :size => 8 do
        text doctor.vcard.street_address
        text doctor.vcard.postal_code + " " + doctor.vcard.locality

        contacts = doctor.vcard.contacts
        labels = contacts.collect{|contact| contact.label}
        numbers = contacts.collect{|contact| contact.number}

        bounding_box([0.cm, cursor - 0.2.cm], :width => 2.cm) do
          bounding_box([0.cm, bounds.top], :width => 0.8.cm) do
            text labels.join("\n")
          end

          bounding_box([1.cm, bounds.top], :width => 5.cm) do
            text numbers.join("\n")
          end
        end
      end
    end

    # Date
    bounding_box([11.5.cm, 24.cm], :width => 6.cm) do
      text doctor.vcard.locality + ", " + Date.today.to_s
    end

    # receiver address
    bounding_box([11.5.cm, 21.5.cm], :width => 6.cm) do
      text recall.patient.honorific_prefix
      text recall.patient.given_name + " " + recall.patient.family_name
      text recall.patient.vcard.street_address
      text recall.patient.vcard.postal_code + " " + recall.patient.vcard.locality
    end

    # Subject
    bounding_box([1.7.cm, 16.cm], :width => 16.cm) do
      font "Helvetica", :style => :bold do
        text "Vorsorge lohnt sich!"
      end
    end

    # Greeting
    bounding_box([1.7.cm, 14.5.cm], :width => 16.cm) do
      greeting(recall.patient)

      text "Wie besprochen erlauben wir uns, Sie an die nächste Untersuchung zu erinnern."
      text "Wir haben für Sie folgenden Terminvorschlag reserviert:"

      text "\n"

      font "Helvetica", :style => :bold do
        text "#{recall.appointment.date}, #{recall.appointment.from} Uhr"
      end

      text "\n"

      text "Sollte Ihnen der Termin nicht passen, danken wir Ihnen für eine möglichst baldige Meldung. Gerne verabreden wir mit Ihnen dann ein anderes Datum."

    end

    # Salutations
    bounding_box([11.5.cm, 7.5.cm], :width => 6.cm) do
      text "Mit freundlichen Grüssen"

      text "\n"
      text "\n"

      text doctor.honorific_prefix + " " + doctor.family_name
      text "und Praxisteam"
    end

    render
  end
end
