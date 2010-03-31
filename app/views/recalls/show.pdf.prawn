# define grid
pdf.define_grid(:columns => 11, :rows => 16, :gutter => 2)#.show_all('EEEEEE')

# address headers
pdf.grid([0,1], [1,6]).bounding_box do
  pdf.text [@current_doctor.honorific_prefix, @current_doctor.full_name].join(' ')
  pdf.font "Helvetica", :size => 8 do
    pdf.text @current_doctor.street_address
    pdf.text @current_doctor.postal_code + " " + @current_doctor.locality
    pdf.text contact(@current_doctor.vcard, "\n")
  end
end

pdf.grid([0,7], [1,9]).bounding_box do
  pdf.text @recall.patient.full_name
  pdf.text @recall.patient.street_address
  pdf.text @recall.patient.postal_code + " " + @recall.patient.locality
end

# Date
pdf.grid([4,7],[4,9]).bounding_box do
  pdf.text @current_doctor.locality + ", " + Date.today.to_s
end

# Subject
pdf.grid([5,1],[5,9]).bounding_box do
  pdf.text "VORSORGE LOHNT SICH!"
end

pdf.grid([6,1],[6,9]).bounding_box do
  pdf.text "Sehr geehrte Frau " + @recall.patient.family_name # TODO could be man, too
end

pdf.grid([7,1],[7,9]).bounding_box do
  pdf.text "Sie sind bei uns letztes Jahr zur Kontrolle gewesen. Wir erlauben uns, Sie an die nächste Untersuchung zu erinnern."
end

pdf.grid([8,1],[8,9]).bounding_box do
  pdf.text "Als Terminvorschlag haben wir für Sie"
  pdf.font "Helvetica", :style => :bold do
    pdf.text "#{@recall.appointment.date}, #{@recall.appointment.from}"
  end
  pdf.text "reserviert."
end

pdf.grid([9,1],[9,9]).bounding_box do
  pdf.text "Sollte Ihnen der Termin nicht passen, danken wir Ihnen für eine möglichst baldige Meldung. Gerne verabreden wir mit Ihnen dann ein anderes Untersuchungsdatum."
end

pdf.grid([12,7],[12,9]).bounding_box do
  pdf.text "Mit freundlichen Grüssen"
end

pdf.grid([13,7],[13,9]).bounding_box do
  pdf.text @current_doctor.honorific_prefix + " " + @current_doctor.family_name
  pdf.text "und Praxisteam"
end
