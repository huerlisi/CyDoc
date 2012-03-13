module Prawn
  class InsuranceRecipe < Prawn::LetterDocument
    include InvoicesHelper

    RECORD_INDENT = 2.2.cm
    SMALL_FONT_SIZE = 6.5
    MEDIUM_FONT_SIZE = 8

    def default_options
      parent_options = super
      parent_options.merge(:top_margin => 1.4.cm, :left_margin => 1.cm, :right_margin => 1.cm, :bottom_margin => 1.8.cm)
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

      # start_new_page if invoice.service_records.count > 10

      # Tarmed footer
      # tarmed_footer(invoice)

      # Summary
      # summary(invoice)

      repeat :all do
        font_size 10
        font Rails.root.join('data', 'ocrb10.ttf')
        draw_text invoice.esr9(invoice.biller.esr_account), :at => [5.6.cm, 0.cm]
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
        ["Dokument", nil, "▪ #{invoice.id} #{invoice.updated_at.strftime('%d.%m.%Y %H:%M:%S')}", " "*30 + "Seite    <font size='8'>▪ 1</font>"], # This uses a non-breaking space!
        ["Rechnungs-", "EAN-Nr.", "▪ #{invoice.biller.ean_party}", full_address(invoice.biller.vcard, ', ')],
        ["steller", "ZSR-Nr.", "▪ #{invoice.biller.zsr}", contact(invoice.biller.vcard, ', ')],
        ["Leistungs-", "EAN-Nr.", "▪ #{invoice.provider.ean_party}", full_address(invoice.provider.vcard, ', ')],
        ["erbringer", "ZSR-Nr./NIF-Nr.", "▪ #{invoice.provider.zsr}", contact(invoice.provider.vcard, ', ')],
      ]

      large_content = [
        ["Patient", "Name", "▪ #{invoice.patient_vcard.family_name}", " "*30 + "EAN-Nr. <font size='8'>▪</font>"],
        [nil, "Vorname", "▪ #{invoice.patient_vcard.given_name}", nil],
        [nil, "Strasse", "▪ #{invoice.patient_vcard.street_address}", nil],
        [nil, "PLZ", "▪ #{invoice.patient_vcard.postal_code}", nil],
        [nil, "Ort", "▪ #{invoice.patient_vcard.locality}", nil],
        [nil, "Geburtsdatum", "▪ #{invoice.patient.birth_date}", nil],
        [nil, "Geschlecht", "▪ #{invoice.patient.sex}", nil],
        [nil, "Unfalldatum", "▪", nil],
        [nil, "Unfall-/Verfüg.Nr.", "▪ #{invoice.law.case_id}", nil],
        [nil, "AHV-Nr.", "▪ #{invoice.law.ssn}", nil],
        [nil, "Versicherten-Nr.", "▪ #{invoice.law.insured_id}", nil],
        [nil, "Betriebs-Nr./-Name", "▪", nil],
        [nil, "Kanton", "▪ #{invoice.treatment.canton}", nil],
        [nil, "Rechnungskopie", "▪ Nein", nil],
        [nil, "Vergütungsart", "▪ #{invoice.tiers.name}", nil],
        [nil, "Gesetz", "▪ #{invoice.law.name}", nil],
        [nil, "Behandlungsgrund", "▪ #{invoice.treatment.reason}", nil],
        [nil, "Behandlung", "▪ #{invoice.date_begin} - #{invoice.date_end}", " "*4 + "Rechnungsnr.                  <font size='8'>▪ #{invoice.id}</font>"],
        [nil, "Erbringungsort", "▪ #{invoice.place_type}", " "*4 + "Rechnungs-/Mahndatum <font size='8'>▪ #{invoice.value_date}</font>"],

        ["Auftraggeber", "EAN-Nr./ZSR-Nr.", "▪ #{ean_zsr(invoice.referrer) if invoice.referrer}", invoice.referrer ? full_address(invoice.referrer, ', ') : nil],
        ["Diagnose", "▪ " + invoice.treatment.medical_cases.map {|d| d.diagnosis.type}.uniq.join('; '), "▪ " + invoice.treatment.medical_cases.map {|d| d.diagnosis.code}.join('; '), nil],
        ["EAN-Liste", invoice.biller.ean_party.present? ? ("▪ 1/" + invoice.biller.ean_party) : nil, nil, nil],
        ["Bemerkungen", invoice.remark, nil, nil],
      ]

      content = (format.eql?(:small) ? small_content : small_content + large_content)

      table content, :width => bounds.width, :cell_style => { :inline_format => true } do
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
      font_size 10 do
        bounding_box [12.cm, bounds.top - 3.5.cm], :width => 7.cm do
          draw_address(invoice.billing_vcard)
        end unless format.eql?(:small)
      end
    end

    def tarmed_footer(invoice)
      content = [
        [
          "▪ " + I18n::translate(:pfl, :scope => "activerecord.attributes.invoice"),
          I18n::translate(:tarmed_al, :scope => "activerecord.attributes.invoice"),
          sprintf('%0.2f', invoice.amount_mt("001").currency_round),
          tax_points_mt(invoice, "001"),
          I18n::translate(:physio, :scope => "activerecord.attributes.invoice"),
          sprintf('%0.2f', invoice.amount("311").currency_round),
          tax_points(invoice, "311"),
          I18n::translate(:mi_gel, :scope => "activerecord.attributes.invoice"),
          sprintf('%0.2f', invoice.amount("452").currency_round),
          tax_points(invoice, "452"),
          I18n::translate(:others, :scope => "activerecord.attributes.invoice"),
          "0.00",
          nil
        ],
        [
          nil,
          I18n::translate(:tarmed_tl, :scope => "activerecord.attributes.invoice"),
          sprintf('%0.2f', invoice.amount_tt("001").currency_round),
          tax_points_tt(invoice, "001"),
          I18n::translate(:laboratory, :scope => "activerecord.attributes.invoice"),
          sprintf('%0.2f', invoice.amount(["316", "317"]).currency_round),
          tax_points(invoice, ["316", "317"]),
          I18n::translate(:medi, :scope => "activerecord.attributes.invoice"),
          sprintf('%0.2f', invoice.amount("400").currency_round),
          tax_points(invoice, "400"),
          I18n::translate(:cantonal, :scope => "activerecord.attributes.invoice"),
          "0.00",
          nil
        ]
      ]

      move_cursor_to 6.5.cm
      font_size MEDIUM_FONT_SIZE
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
    end

    def service_records(invoice)
      service_record_header

      first_page_records = invoice.service_records.first(17)

      for record in first_page_records
        service_entry(record)
      end

      sub_total(first_page_records)
      start_new_page
      page_records = invoice.service_records.shift(17).each_slice(24).to_a

      page_records.each do |records|
        bounding_box [0, cursor - 3.cm], :width => bounds.width do
          service_record_header

          records.each do |record|
            service_entry(record)
          end

          sub_total(records) unless records.eql?(page_records.last) 
        end

        start_new_page unless records.eql?(page_records.last)
      end
    end

    def sub_total(records)
      new_line
      temp_cursor = cursor

      font_size(MEDIUM_FONT_SIZE) do
        text "Zwischentotal", :style => :bold
        text_box "CHF", :at => [RECORD_INDENT, temp_cursor], :style => :bold
        text_box "#{records.sum(&:amount)}", :width => 2.cm, 
                                             :at => [bounds.width - 2.cm, temp_cursor], 
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
            sprintf('%.2f', record.amount)
          ]

          table [data], :cell_style => {:overflow => :shrink_to_fit} do
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

        move_down 5
      end
    end

    def new_line
      text " "
    end

    def summary(invoice)
      content = [
        [
          "▪ " + I18n::translate(:total_amount, :scope => "activerecord.attributes.invoice"),
          invoice.amount.currency_round,
          nil,
          I18n::translate(:amount_pfl, :scope => "activerecord.attributes.invoice"),
          invoice.obligation_amount.currency_round,
          nil,
          I18n::translate(:prepayment, :scope => "activerecord.attributes.invoice"),
          "0.00",
          nil,
          I18n::translate(:amount_due, :scope => "activerecord.attributes.invoice"),
          sprintf('%0.2f', invoice.amount.currency_round),
          nil
        ]
      ]

      move_down 8
      font_size 8
      table content do
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
        column(4).width = 1.2.cm
        column(5).width = 1.2.cm
        column(6).width = 1.8.cm
        column(7).width = 1.cm
        column(8).width = 1.3.cm
        column(9).width = 2.4.cm
        column(10).width = 1.2.cm
      end

      move_down 8
      font_size 6.5
      text "▪ " + I18n::translate(:vat_number, :scope => "activerecord.attributes.invoice"), :style => :bold

      header = [
        [
          "▪ " + I18n::translate(:vat_code, :scope => "activerecord.attributes.invoice"),
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
          sprintf('%0.2f', invoice.amount.currency_round),
          "0.00"
        ]
      ]

      footer = [
        [
          I18n::translate(:total, :scope => "activerecord.attributes.invoice"),
          nil,
          invoice.amount.currency_round,
          "0.00"
        ]
      ]

      move_down 2.cm
      font_size 8
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
