require 'prawn/measurement_extensions'

# Fonts
font_path = '/usr/share/fonts/truetype/ttf-dejavu/'
pdf.font_families.update(
  "DejaVuSans" => { :bold        => font_path + "DejaVuSans-Bold.ttf",
                    :normal      => font_path + "DejaVuSans.ttf"
  })


# Title
pdf.font "DejaVuSans"
pdf.font_size 16
pdf.draw_text "Rückforderungsbeleg", :style => :bold, :at => [-1, pdf.bounds.top + 0.25.cm]

pdf.draw_text "M", :style => :bold, :at => [pdf.bounds.right - 14, pdf.bounds.top + 0.25.cm]

pdf.font_size 7
pdf.draw_text "Release ▪ 4.0M/de", :at => [pdf.bounds.right - 100, pdf.bounds.top + 0.25.cm]

# Head
content = [
  ["Dokument", nil, "▪ #{@invoice.id} #{@invoice.updated_at.strftime('%d.%m.%Y %H:%M:%S')}", " "*30 + "Seite    <font size='8'>▪ 1</font>"], # This uses a non-breaking space!
  ["Rechnungs-", "EAN-Nr.", "▪ #{@invoice.biller.ean_party}", full_address(@invoice.biller.vcard, ', ')],
  ["steller", "ZSR-Nr.", "▪ #{@invoice.biller.zsr}", contact(@invoice.biller.vcard, ', ')],
  ["Leistungs-", "EAN-Nr.", "▪ #{@invoice.provider.ean_party}", full_address(@invoice.provider.vcard, ', ')],
  ["erbringer", "ZSR-Nr./NIF-Nr.", "▪ #{@invoice.provider.zsr}", contact(@invoice.provider.vcard, ', ')],

  ["Patient", "Name", "▪ #{@invoice.patient.vcard.family_name}", " "*30 + "EAN-Nr. <font size='8'>▪</font>"],
  [nil, "Vorname", "▪ #{@invoice.patient.vcard.given_name}", nil],
  [nil, "Strasse", "▪ #{@invoice.patient.vcard.street_address}", nil],
  [nil, "PLZ", "▪ #{@invoice.patient.vcard.postal_code}", nil],
  [nil, "Ort", "▪ #{@invoice.patient.vcard.locality}", nil],
  [nil, "Geburtsdatum", "▪ #{@invoice.patient.birth_date}", nil],
  [nil, "Geschlecht", "▪ #{@invoice.patient.sex}", nil],
  [nil, "Unfalldatum", "▪", nil],
  [nil, "Unfall-/Verfüg.Nr.", "▪ #{@invoice.law.case_id}", nil],
  [nil, "AHV-Nr.", "▪ #{@invoice.law.ssn}", nil],
  [nil, "Versicherten-Nr.", "▪ #{@invoice.law.insured_id}", nil],
  [nil, "Betriebs-Nr./-Name", "▪", nil],
  [nil, "Kanton", "▪ #{@invoice.treatment.canton}", nil],
  [nil, "Rechnungskopie", "▪ Nein", nil],
  [nil, "Vergütungsart", "▪ #{@invoice.tiers.name}", nil],
  [nil, "Gesetz", "▪ #{@invoice.law.name}", nil],
  [nil, "Behandlungsgrund", "▪ #{@invoice.treatment.reason}", nil],
  [nil, "Behandlung", "▪ #{@invoice.date_begin} - #{@invoice.date_end}", " "*4 + "Rechnungsnr.                  <font size='8'>▪ #{@invoice.id}</font>"],
  [nil, "Erbringungsort", "▪ #{@invoice.place_type}", " "*4 + "Rechnungs-/Mahndatum <font size='8'>▪ #{@invoice.value_date}</font>"],

  ["Auftraggeber", "EAN-Nr./ZSR-Nr.", "▪ #{ean_zsr(@invoice.referrer)}", full_address(@invoice.referrer, ', ')],
  ["Diagnose", "▪ " + @invoice.treatment.medical_cases.map {|d| d.diagnosis.type}.uniq.join('; '), "▪ " + @invoice.treatment.medical_cases.map {|d| d.diagnosis.code}.join('; '), nil],
  ["EAN-Liste", "▪ 1/" + @invoice.biller.ean_party, nil, nil],
  ["Bemerkungen", @invoice.remark, nil, nil],
]

pdf.font_size 8
pdf.table content, :width => pdf.bounds.width, :cell_style => { :inline_format => true } do
  # General
  cells.border_width = 0
  cells.padding = [0.5, 2, 0.5, 2]
  
  # Surrounding Border
  row(0).border_top_width = 0.75
  row(-1).border_bottom_width = 0.75
  column(0).border_left_width = 0.75
  column(-1).border_right_width = 0.75
  row(0).padding_top = 1
  row(-1).padding_bottom = 1

  # Separators
  row(4).border_bottom_width = 0.75
  row(23).border_bottom_width = 0.75
  row(24).border_bottom_width = 0.75
  row(25).border_bottom_width = 0.75
  row(26).border_bottom_width = 0.75

  row(4).padding_bottom = 1
  row(5).padding_top = 1
  row(23).padding_bottom = 1
  row(24).padding_bottom = 1
  row(25).padding_bottom = 1
  row(26).padding_bottom = 1

  # Title column
  column(0).font_style = :bold

  # Column widths
  column(0).width = 2.cm
  column(1).width = 2.5.cm
  column(2).width = 4.6.cm
  column(4).width = 4.7.cm

  column(1).size = 6.5
  column(0).size = 6.5
  column(3).size = 6.5

  row(-1).height = 20
end

# Patient address
pdf.font_size 10
pdf.bounding_box [12.cm, pdf.bounds.top - 3.5.cm], :width => 6.cm do
  @invoice.patient.vcard.full_address_lines.each do |line|
    pdf.text line
  end
end

# Service records
pdf.move_cursor_to 14.5.cm
pdf.font_size = 6.5
data = [
  "Datum",
  "Tarif",
  "Tarifziffer",
  "Bezugsziffer",
  "Si St",
  "Anzahl",
  "TP AL/Preis",
  "f AL",
  "TPW AL",
  "TP TL",
  "f TL",
  "TPW TL",
  "A",
  "V",
  "P",
  "M",
  "Betrag",
]

pdf.table [data], :cell_style => {:overflow => :shrink_to_fit} do
  cells.borders = []
  cells.padding = 0

  column(0).width = 2.2.cm
  column(1).width = 0.9.cm
  column(2).width = 1.5.cm
  column(3).width = 1.7.cm
  column(4).width = 0.8.cm
  column(5).width = 1.cm
  column(6).width = 1.7.cm
  column(7).width = 1.4.cm
  column(8).width = 1.4.cm
  column(9).width = 1.4.cm
  column(10).width = 1.1.cm
  column(11).width = 1.1.cm
  column(12).width = 0.5.cm
  column(13).width = 0.3.cm
  column(14).width = 0.3.cm
  column(15).width = 0.3.cm
  column(16).width = 1.4.cm

  column(5..16).align = :right
end

pdf.move_down 5

for record in @invoice.service_records
  pdf.font_size 6.5
  pdf.indent 2.2.cm do
    pdf.text record.text, :style => :bold, :leading => -1
  end

  pdf.font_size 8
  data = [
    "▪ " + record.date.to_date.to_s,
    sprintf('%03i', record.tariff_type),
    record.code,
    record.ref_code,
    record.session,
    sprintf('%.2f', record.quantity),
    sprintf('%.2f', record.amount_mt),
    sprintf('%.2f', record.unit_factor_mt),
    sprintf('%.2f', record.unit_mt),
    sprintf('%.2f', record.amount_tt),
    sprintf('%.2f', record.unit_factor_tt),
    sprintf('%.2f', record.unit_tt),
    1,
    1,
    0,
    0,
    sprintf('%.2f', record.amount)
  ]

  pdf.table [data], :cell_style => {:overflow => :shrink_to_fit} do
    cells.borders = []
    cells.padding = 0

    column(0).width = 2.2.cm
    column(1).width = 0.9.cm
    column(2).width = 1.5.cm
    column(3).width = 1.7.cm
    column(4).width = 0.8.cm
    column(5).width = 1.cm
    column(6).width = 1.7.cm
    column(7).width = 1.4.cm
    column(8).width = 1.4.cm
    column(9).width = 1.4.cm
    column(10).width = 1.1.cm
    column(11).width = 1.1.cm
    column(12).width = 0.5.cm
    column(13).width = 0.3.cm
    column(14).width = 0.3.cm
    column(15).width = 0.3.cm
    column(16).width = 1.4.cm

    column(5..16).align = :right
  end

  pdf.move_down 3
end

# Tarmed footer
content = [
  [
    "▪ " + t_attr(:pfl),
    t_attr(:tarmed_al),
    sprintf('%0.2f', @invoice.amount_mt("001").currency_round),
    tax_points_mt(@invoice, "001"),
    t_attr(:physio),
    "0.00",
    nil,
    t_attr(:mi_gel),
    sprintf('%0.2f', @invoice.amount("452").currency_round),
    tax_points(@invoice, "452"),
    t_attr(:others),
    "0.00",
    nil
  ],
  [
    nil,
    t_attr(:tarmed_tl),
    sprintf('%0.2f', @invoice.amount_tt("001").currency_round),
    tax_points_tt(@invoice, "001"),
    t_attr(:laboratory),
    sprintf('%0.2f', @invoice.amount(["316", "317"]).currency_round),
    tax_points(@invoice, ["316", "317"]),
    t_attr(:medi),
    sprintf('%0.2f', @invoice.amount("400").currency_round),
    tax_points(@invoice, "400"),
    t_attr(:cantonal),
    "0.00",
    nil
  ]
]

pdf.move_cursor_to 6.5.cm
pdf.font_size 8
pdf.table content, :width => pdf.bounds.width do
  # General
  cells.borders = []
  cells.padding = [0.5, 2, 0.5, 2]

  # Outer cells
  column(0).padding_left = 0
  column(-1).padding_right = 0

  # Padding
  column(4).padding_left = 1.cm

  # Fonts
  column(0).font_style = :bold

  column(0).size = 6.5
  column(1).size = 6.5
  column(4).size = 6.5
  column(7).size = 6.5
  column(10).size = 6.5
  column(13).size = 6.5

  # Alignments
  column(2).align = :right
  column(3).align = :right
  column(5).align = :right
  column(6).align = :right
  column(8).align = :right
  column(9).align = :right
  column(11).align = :right
  column(12).align = :right
  column(14).align = :right
  column(15).align = :right

  # Width
  column(0).width = 1.5.cm
  column(1).width = 1.7.cm
  column(2).width = 1.3.cm
  column(3).width = 1.3.cm
  column(4).width = 2.3.cm
  column(5).width = 1.7.cm
  column(6).width = 1.2.cm
  column(7).width = 1.3.cm
  column(8).width = 1.5.cm
  column(9).width = 1.3.cm
  column(10).width = 1.9.cm
  column(11).width = 1.7.cm
end

# Summary
content = [
  [
    "▪ " + t_attr(:total_amount),
    @invoice.amount.currency_round,
    nil,
    t_attr(:amount_pfl),
    @invoice.obligation_amount.currency_round,
    nil,
    t_attr(:prepayment),
    "0.00",
    nil,
    t_attr(:amount_due),
    sprintf('%0.2f', @invoice.amount.currency_round),
    nil
  ]
]

pdf.move_down 8
pdf.font_size 8
pdf.table content do
  # General
  cells.borders = []
  cells.padding = [0.5, 2, 0.5, 2]

  # Outer cells
  column(0).padding_left = 0
  column(-1).padding_right = 0

  # Padding
  column(3).padding_left = 1.cm

  # Fonts
  row(0).font_style = :bold

  column(0).size = 6.5
  column(3).size = 6.5
  column(6).size = 6.5
  column(9).size = 6.5

  # Alignments
  column(1).align = :right
  column(4).align = :right
  column(7).align = :right
  column(10).align = :right

  # Width
  column(0).width = 2.8.cm
  column(1).width = 1.7.cm
  column(2).width = 1.3.cm
  column(3).width = 3.cm
  column(4).width = 1.0.cm
  column(5).width = 1.2.cm
  column(6).width = 1.8.cm
  column(7).width = 1.cm
  column(8).width = 1.3.cm
  column(9).width = 2.4.cm
  column(10).width = 1.2.cm
end

pdf.move_down 8
pdf.font_size 6.5
pdf.text "▪ " + t_attr(:vat_number), :style => :bold

header = [
  [
    "▪ " + t_attr(:vat_code),
    t_attr(:vat_rate),
    t_attr(:vat_amount),
    t_attr(:vat)
  ]
]

total_vat_amount = 0.0
content = [
  [
    "0",
    "0.00",
    sprintf('%0.2f', @invoice.amount.currency_round),
    "0.00"
  ]
]

footer = [
  [
    t_attr(:total),
    nil,
    @invoice.amount.currency_round,
    "0.00"
  ]
]

pdf.move_down 2.cm
pdf.font_size 8
pdf.table header + content + footer do
  # General
  cells.borders = []
  cells.padding = [0.5, 2, 0.5, 2]

  # Outer cells
  column(0).padding_left = 0
  column(-1).padding_right = 0

  # Alignments
  cells.align = :right
  column(0).align = :left

  # Fonts
  row(0).font_style = :bold
  row(-1).font_style = :bold

  row(0).size = 6.5

  # Column widths
  cells.width = 2.cm
  column(0).width = 1.cm
end

pdf.font_size 10
pdf.font Rails.root.join('data', 'ocrb10.ttf')
pdf.draw_text @invoice.esr9(@invoice.biller.esr_account), :at => [5.6.cm, -0.8.cm]
