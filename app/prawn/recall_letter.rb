module Prawn
  class RecallLetter < Prawn::LetterDocument
    def greeting(patient)
      text patient.vcard.salutation
      text " "
    end

    def to_pdf(recall, params = {})
      doctor = recall.doctor

      letter_header(recall.doctor, recall.patient, "Vorsorge lohnt sich!")

      text " "

      greeting(recall.patient)

      text "Wie besprochen erlauben wir uns, Sie an die nächste Untersuchung zu erinnern."
      text "Wir haben für Sie folgenden Terminvorschlag reserviert:"

      text " "

      text "#{recall.appointment.date}, #{recall.appointment.from} Uhr", :style => :bold

      text " "

      text "Sollte Ihnen der Termin nicht passen, danken wir Ihnen für eine möglichst baldige Meldung. Gerne verabreden wir mit Ihnen dann ein anderes Datum."

      # Salutations
      common_closing(doctor)

      render
    end
  end
end
