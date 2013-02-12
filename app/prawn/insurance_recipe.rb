# -*- encoding : utf-8 -*-
class InsuranceRecipe < LetterDocument
  include InvoicesHelper
  include AccountsHelper

  RECORD_INDENT = 3.1.cm
  SMALL_FONT_SIZE = 6.5
  MEDIUM_FONT_SIZE = 8
  BORDER_WIDTH = 0.75

  def default_options
    parent_options = super
    parent_options.merge(:top_margin => 1.8.cm, :left_margin => 1.cm, :right_margin => 1.cm, :bottom_margin => 1.8.cm)
    parent_options[:template] = nil
    parent_options
  end

  def initialize_fonts
    # Fonts
    font_path = '/usr/share/fonts/truetype/ttf-dejavu/'
    font_families.update(
      "DejaVuSans" => { :bold        => font_path + "DejaVuSans-Bold.ttf",
                        :normal      => font_path + "DejaVuSans.ttf" }
    )

    font 'DejaVuSans'
  end

  def to_pdf(invoice, params = {})
    # Title, repeated on all pages.
    repeat :all do
      title
    end

    bounding_box [0, bounds.height], :width => bounds.width, :height => 12.cm do
      info_header(invoice)
    end

    repeat (lambda { |pg| pg != 1 }) do
      bounding_box [0, bounds.height], :width => bounds.width, :height => 4.cm do
        info_header(invoice, :small)
      end
    end

    move_down 7.5.cm
    # Service records
    service_records(invoice)

    footer_last_page(invoice)

    # Page number
    number_pages "<page>", :at => [bounds.width - 5.3.cm, bounds.height - 0.1.cm], :font_size => SMALL_FONT_SIZE

    repeat :all do
      font_size 10
      font Rails.root.join('data', 'ocrb10.ttf')
      text_box invoice.esr9(invoice.biller.esr_account), :width => bounds.width,
                                                         :height => 1.cm,
                                                         :at => [0.cm, 0.cm],
                                                         :align => :right
    end

    render
  end

  def title
    bounding_box [0, cursor + 0.3.cm], :width => bounds.width, :height => 0.7.cm do
      line = bounds.top

      font_size(16) do
        draw_text "Rückforderungsbeleg", :style => :bold, :at => [bounds.left, line]
        draw_text "M", :style => :bold, :at => [bounds.right - 14, line]
      end

      font_size 7
      draw_text "Release ▪ 4.0M/de", :at => [bounds.right - 100, line]
      font_size MEDIUM_FONT_SIZE
    end
  end

  def info_header(invoice, format = :default)
    # Head
    small_content = [
      ["Dokument", '', "▪ #{invoice.id} #{invoice.updated_at.strftime('%d.%m.%Y %H:%M:%S')}", " "*30 + "Seite    <font size='8'>▪ </font>"], # This uses a non-breaking space!
      ["Rechnungs-", "EAN-Nr.", "▪ #{invoice.biller.ean_party}", full_address(invoice.biller.vcard, ', ')],
      ["steller", "ZSR-Nr.", "▪ #{invoice.biller.zsr}", contact(invoice.biller.vcard, ', ')],
      ["Leistungs-", "EAN-Nr.", "▪ #{invoice.provider.ean_party}", full_address(invoice.provider.vcard, ', ')],
      ["erbringer", "ZSR-Nr./NIF-Nr.", "▪ #{invoice.provider.zsr}", contact(invoice.provider.vcard, ', ')],
    ]

    large_content = [
      ["Patient", "Name", "▪ #{invoice.patient_vcard.family_name}", " "*30 + "EAN-Nr. <font size='8'>▪</font>"],
      ['', "Vorname", "▪ #{invoice.patient_vcard.given_name}", ''],
      ['', "Strasse", "▪ #{invoice.patient_vcard.street_address}", ''],
      ['', "PLZ", "▪ #{invoice.patient_vcard.postal_code}", ''],
      ['', "Ort", "▪ #{invoice.patient_vcard.locality}", ''],
      ['', "Geburtsdatum", "▪ #{invoice.patient.birth_date}", ''],
      ['', "Geschlecht", "▪ #{invoice.patient.sex}", ''],
      ['', "Unfalldatum", "▪", ''],
      ['', "Unfall-/Verfüg.Nr.", "▪ #{invoice.law.case_id}", ''],
      ['', "AHV-Nr.", "▪ #{invoice.law.ssn}", ''],
      ['', "Versicherten-Nr.", "▪ #{invoice.law.insured_id}", ''],
      ['', "Betriebs-Nr./-Name", "▪", ''],
      ['', "Kanton", "▪ #{invoice.treatment.canton}", ''],
      ['', "Rechnungskopie", "▪ Nein", ''],
      ['', "Vergütungsart", "▪ #{invoice.tiers.name}", ''],
      ['', "Gesetz", "▪ #{invoice.law.name}", ''],
      ['', "Behandlungsgrund", "▪ #{invoice.treatment.reason}", ''],
      ['', "Behandlung", "▪ #{invoice.date_begin} - #{invoice.date_end}", " "*4 + "Rechnungsnr.                  <font size='8'>▪ #{invoice.id}</font>"],
      ['', "Erbringungsort", "▪ #{invoice.place_type}", " "*4 + "Rechnungs-/Mahndatum <font size='8'>▪ #{invoice.value_date}</font>"],

      ["Auftraggeber", "EAN-Nr./ZSR-Nr.", "▪ #{ean_zsr(invoice.referrer) if invoice.referrer}", invoice.referrer ? full_address(invoice.referrer.vcard, ', ') : ''],
      ["Diagnose", "▪ " + invoice.treatment.medical_cases.map {|d| d.diagnosis.type}.uniq.join('; '), "▪ " + invoice.treatment.medical_cases.map {|d| d.diagnosis.code}.join('; '), ''],
      ["EAN-Liste", {:content => (invoice.biller.ean_party.present? ? ("▪ 1/" + invoice.biller.ean_party) : ""), :colspan => 3}],
      ["Bemerkungen", {:content => invoice.remark.to_s, :colspan => 3}],
    ]

    patient = [["Patient", {:content => "#{invoice.patient_vcard.family_name} #{invoice.patient_vcard.given_name}, #{invoice.patient.birth_date}", :colspan => 3}]]

    content = (format.eql?(:small) ? small_content + patient : small_content + large_content)
    table content, :width => bounds.width, :cell_style => { :inline_format => true } do
      # General
      cells.border_width = 0
      cells.padding = [0.5, 2, 0.5, 2]

      # Surrounding Border
      row(0).border_top_width = BORDER_WIDTH
      row(-1).border_bottom_width = BORDER_WIDTH
      row(-1).border_bottom_width = BORDER_WIDTH
      column(0).border_left_width = BORDER_WIDTH
      column(-1).border_right_width = BORDER_WIDTH

      row(0).padding_top = 1
      row(-1).padding_bottom = 1

      # Separators
      row(4).border_bottom_width = BORDER_WIDTH
      row(4).padding_bottom = 1
      row(5).padding_top = 1

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

      if format == :small
        row(-1).height = 12
        row(-1).column(1).border_right_width = BORDER_WIDTH
      else
        row(-1).height = 20
        row(26).column(1).border_right_width = BORDER_WIDTH
        row(27).column(1).border_right_width = BORDER_WIDTH

        row(23).border_bottom_width = BORDER_WIDTH
        row(24).border_bottom_width = BORDER_WIDTH
        row(25).border_bottom_width = BORDER_WIDTH
        row(26).border_bottom_width = BORDER_WIDTH
     end
    end

    # Patient address
    font_size 10 do
      bounding_box [12.cm, bounds.top - 3.5.cm], :width => 7.cm do
        draw_address(invoice.billing_vcard)
      end unless format.eql?(:small)
    end
  end

  def footer_last_page(invoice)
    start_new_page if new_page?

    bounding_box [0, footer_position], :width => bounds.width do
      # Tarmed footer
      tarmed_footer(invoice)

      text " "

      # Summary
      summary(invoice)
    end
  end

  def new_page?
    cursor < footer_position
  end

  def footer_position
    bounds.bottom + 5.2.cm
  end

  def tarmed_footer(invoice)
    content = [
      [
        "▪ " + I18n::translate(:pfl, :scope => "activerecord.attributes.invoice"),
        I18n::translate(:tarmed_al, :scope => "activerecord.attributes.invoice"),
        currency_fmt(invoice.amount_mt("001").currency_round),
        tax_points_mt(invoice, "001"),
        I18n::translate(:physio, :scope => "activerecord.attributes.invoice"),
        currency_fmt(invoice.amount("311").currency_round),
        tax_points(invoice, "311"),
        I18n::translate(:mi_gel, :scope => "activerecord.attributes.invoice"),
        currency_fmt(invoice.amount("452").currency_round),
        tax_points(invoice, "452"),
        I18n::translate(:others, :scope => "activerecord.attributes.invoice"),
        "0.00",
        ''
      ],
      [
        '',
        I18n::translate(:tarmed_tl, :scope => "activerecord.attributes.invoice"),
        currency_fmt(invoice.amount_tt("001").currency_round),
        tax_points_tt(invoice, "001"),
        I18n::translate(:laboratory, :scope => "activerecord.attributes.invoice"),
        currency_fmt(invoice.amount(["316", "317"]).currency_round),
        tax_points(invoice, ["316", "317"]),
        I18n::translate(:medi, :scope => "activerecord.attributes.invoice"),
        currency_fmt(invoice.amount("400").currency_round),
        tax_points(invoice, "400"),
        I18n::translate(:cantonal, :scope => "activerecord.attributes.invoice"),
        "0.00",
        ''
      ],
      [
        {:content => "▪ " + I18n::translate(:total_amount, :scope => "activerecord.attributes.invoice"), :colspan => 2},
        currency_fmt(invoice.amount.currency_round),
        '',
        I18n::translate(:amount_pfl, :scope => "activerecord.attributes.invoice"),
        currency_fmt(invoice.obligation_amount.currency_round),
        '',
        I18n::translate(:prepayment, :scope => "activerecord.attributes.invoice"),
        "0.00",
        '',
        I18n::translate(:amount_due, :scope => "activerecord.attributes.invoice"),
        currency_fmt(invoice.amount.currency_round),
        ''
      ]
    ]

    font_size SMALL_FONT_SIZE do
      table content, :width => bounds.width do
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

        # Total row styling
        row(2).font_style = :bold
        row(2).padding = [10, 0, 0, 0]
      end
    end
  end

  def new_page(printed_records)
    sub_total(printed_records)

    start_new_page

    move_down 3.cm
    service_record_header
  end

  def service_records(invoice)
    # Print header
    service_record_header

    all_records = invoice.service_records
    printed_records = []

    all_records.each do |record|
      service_entry(record)
      printed_records << record

      new_page(printed_records) if new_page?
    end

    sub_total(page_records.last) if new_page?
  end

  def sub_total(records)
    new_line

    font_size(MEDIUM_FONT_SIZE) do
      temp_cursor = cursor
      text_box "Zwischentotal", :style => :bold, :at => [0, temp_cursor]
      text_box "CHF", :at => [RECORD_INDENT, temp_cursor], :style => :bold
      text_box "#{currency_fmt(records.sum(&:amount).currency_round)}", :width => 5.cm,
                                           :at => [bounds.width - 5.cm, temp_cursor],
                                           :align => :right,
                                           :style => :bold
    end
  end

  def service_entry(record)
    group do
      font_size SMALL_FONT_SIZE do
        indent RECORD_INDENT do
          text record.text, :style => :bold, :leading => -1
        end
      end

      font_size MEDIUM_FONT_SIZE do
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
          currency_fmt(record.amount)
        ]

        table [data], :cell_style => {:overflow => :shrink_to_fit} do
          cells.borders = []
          cells.padding = 0

          column(0).width = 2.2.cm
          column(1).width = 0.9.cm
          column(2).width = 1.5.cm
          column(3).width = 1.7.cm
          column(4).width = 0.7.cm
          column(5).width = 1.cm
          column(6).width = 1.6.cm
          column(7).width = 1.3.cm
          column(8).width = 1.3.cm
          column(9).width = 1.3.cm
          column(10).width = 1.1.cm
          column(11).width = 1.1.cm
          column(12).width = 0.5.cm
          column(13).width = 0.3.cm
          column(14).width = 0.3.cm
          column(15).width = 0.3.cm
          column(16).width = 1.3.cm

          column(5..16).align = :right
        end
      end

      move_down 3
    end
  end

  def service_record_header
    font_size SMALL_FONT_SIZE do
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

      table [data], :cell_style => {:overflow => :shrink_to_fit, :font_style => :bold} do
        cells.borders = []
        cells.padding = 0
        cells.size = 6.5

        column(0).width = 2.2.cm
        column(1).width = 0.9.cm
        column(2).width = 1.5.cm
        column(3).width = 1.7.cm
        column(4).width = 0.7.cm
        column(5).width = 1.cm
        column(6).width = 1.6.cm
        column(7).width = 1.3.cm
        column(8).width = 1.3.cm
        column(9).width = 1.3.cm
        column(10).width = 1.1.cm
        column(11).width = 1.1.cm
        column(12).width = 0.5.cm
        column(13).width = 0.3.cm
        column(14).width = 0.3.cm
        column(15).width = 0.3.cm
        column(16).width = 1.3.cm

        column(5..16).align = :right
      end

      move_down 5
    end
  end

  def new_line
    text " "
  end

  def summary(invoice)
    font_size SMALL_FONT_SIZE do
      text "▪ " + I18n::translate(:vat_number, :scope => "activerecord.attributes.invoice"), :style => :bold
    end

    header = [
      [
        I18n::translate(:vat_code, :scope => "activerecord.attributes.invoice"),
        I18n::translate(:vat_rate, :scope => "activerecord.attributes.invoice"),
        I18n::translate(:vat_amount, :scope => "activerecord.attributes.invoice"),
        I18n::translate(:vat, :scope => "activerecord.attributes.invoice")
      ]
    ]

    total_vat_amount = 0.0
    content = [
      [
        "0",
        "0.00",
        currency_fmt(invoice.amount.currency_round),
        "0.00"
      ]
    ]

    footer = [
      [
        I18n::translate(:total, :scope => "activerecord.attributes.invoice"),
        '',
        currency_fmt(invoice.amount.currency_round),
        "0.00"
      ]
    ]

    font_size SMALL_FONT_SIZE do
      table header + content + footer do
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
    end
  end
end
