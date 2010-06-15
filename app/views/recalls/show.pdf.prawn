# sender address
pdf.bounding_box([1.7.cm, 25.5.cm], :width => 7.cm) do
  pdf.text [@current_doctor.honorific_prefix, @current_doctor.given_name, @current_doctor.family_name].join(' ')
  pdf.font "Helvetica", :size => 8 do
    pdf.text @current_doctor.street_address
    pdf.text @current_doctor.postal_code + " " + @current_doctor.locality

    contacts = @current_doctor.vcard.contacts
    labels = contacts.collect{|contact| contact.label}
    numbers = contacts.collect{|contact| contact.number}

    pdf.bounding_box([0.cm, pdf.cursor - 0.2.cm], :width => 2.cm) do
      pdf.bounding_box([0.cm, pdf.bounds.top], :width => 0.8.cm) do
        pdf.text labels.join("\n")
      end

      pdf.bounding_box([1.cm, pdf.bounds.top], :width => 5.cm) do
        pdf.text numbers.join("\n")
      end
    end
  end
end

# Date
pdf.bounding_box([11.5.cm, 24.cm], :width => 6.cm) do
  pdf.text @current_doctor.locality + ", " + Date.today.to_s
end

# receiver address
pdf.bounding_box([11.5.cm, 21.5.cm], :width => 6.cm) do
  pdf.text @recall.patient.honorific_prefix
  pdf.text @recall.patient.given_name + " " + @recall.patient.family_name
  pdf.text @recall.patient.street_address
  pdf.text @recall.patient.postal_code + " " + @recall.patient.locality
end

# Subject
pdf.bounding_box([1.7.cm, 17.cm], :width => 16.cm) do
  pdf.font "Helvetica", :style => :bold do
    pdf.text "Vorsorge lohnt sich!"
  end
end

# Greeting
pdf.bounding_box([1.7.cm, 15.5.cm], :width => 16.cm) do
  pdf.text "Sehr geehrte Frau " + @recall.patient.family_name # TODO could be man, too

  pdf.text "\n"

  pdf.text "Wie besprochen erlauben wir uns, Sie an die nächste Untersuchung zu erinnern."
  pdf.text "Wir haben für Sie folgenden Terminvorschlag reserviert:"

  pdf.text "\n"

  pdf.font "Helvetica", :style => :bold do
    pdf.text "#{@recall.appointment.date}, #{@recall.appointment.from} Uhr"
  end

  pdf.text "\n"

  pdf.text "Sollte Ihnen der Termin nicht passen, danken wir Ihnen für eine möglichst baldige Meldung. Gerne verabreden wir mit Ihnen dann ein anderes Datum."

end

# Salutations
pdf.bounding_box([11.5.cm, 6.5.cm], :width => 6.cm) do
  pdf.text "Mit freundlichen Grüssen"

  pdf.text "\n"

  pdf.text @current_doctor.honorific_prefix + " " + @current_doctor.family_name
  pdf.text "und Praxisteam"
end
