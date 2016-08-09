# encoding: UTF-8
module Prawn
  class PatientLetter < Prawn::LetterDocument
    include InvoicesHelper
    include EsrRecipe

    # Helpers
    def default_options
      parent_options = super
      parent_options.merge(:top_margin => 35, :left_margin => 12, :right_margin => 12, :bottom_margin => 23)
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

    # Title
    def title(invoice)
      font_size 16
      text "Patientenrechnung Nr. #{invoice.id}", :style => :bold
      font_size 6.5
      text "Diese Seite ist für Ihre Unterlagen, der beilegende Rückforderungsbeleg für Ihre Krankenkasse."
    end

    # Biller / Provider
    def invoice_dates(invoice)
      font_size 6.5
      text "Rechnungs-Datum:"
      font_size 8
      text invoice.value_date.to_s
      font_size 6.5
      text "Zahlbar bis:"
      font_size 8
      text invoice.due_date.to_s
    end

    def biller(invoice)
      font_size 6.5
      text "Rechnungssteller/Leistungserbringer:"
      font_size 8
      draw_address(invoice.biller.vcard, true)

      font_size 6.5 do
        for contact in invoice.biller.vcard.contacts
          text contact.to_s
        end
      end

      text " "
      invoice_dates(invoice)
    end

    # Referrer
    def referrer(invoice)
      font_size 6.5
      text "Zuweisender Arzt:"
      font_size 8
      draw_address(invoice.referrer.vcard, true)
      text " "
    end

    def treatment(invoice)
      font_size 6.5
      text "Behandlung vom:"
      font_size 8
      text invoice.treatment.date_begin.to_s
    end

    # Billing Address
    def billing_address(invoice)
      font_size 10
      draw_address(invoice.billing_vcard, true)
    end

    # Patient
    def patient(invoice)
      font_size 6.5
      text "Patient:"
      font_size 8
      draw_address(invoice.patient_vcard)
      text " "
      font_size 6.5
      text "Geburtsdatum:"
      font_size 8
      text invoice.patient.birth_date.to_s
    end

    # Balance
    def balance(invoice)
      font_size 6.5
      text "Kontoauszug:"
      font_size 8
      content = invoice.bookings.map{|booking|
        [
          booking.value_date,
          booking.title,
          booking.comments.present? ? "<font size='6.5'>#{booking.comments}</font>" : "",
          sprintf("%0.2f CHF", booking.accounted_amount(invoice.balance_account))
        ]
      }
      content << [
        nil,
        invoice.due_amount.currency_round >= 0 ? I18n::translate(:open_amount, Invoice, :scope => "activerecord.attributes.invoice") : I18n::translate(:balance, Invoice, :scope => "activerecord.attributes.invoice"),
        nil,
        sprintf("%0.2f CHF", invoice.due_amount.currency_round)
      ]

      table content, :width => 17.cm, :cell_style => {:inline_format => true} do
        # General
        cells.borders = []
        cells.padding = [0.5, 2, 0.5, 2]

        # With
        column(0).width = 2.5.cm
        column(1).width = 3.5.cm
        column(2).width = 9.cm
        column(3).width = 2.cm

        # Alignment
        column(3).align = :right

        # Total
        row(-1).borders    = [:top]
        row(-1).font_style = :bold
      end
    end

    def esr_recipe(invoice, account, sender, print_payment_for)
      bounding_box [cm2pt(0.4), cm2pt(9.6)], :width => cm2pt(5) do
        indent cm2pt(0.4) do
          draw_account_detail(account.bank, sender, print_payment_for)
        end
        draw_account(account)
        draw_amount(invoice.balance.currency_round)

        bounding_box [cm2pt(0.4), bounds.top - cm2pt(5.2)], :width => cm2pt(5) do
          text esr9_reference(invoice, account), :size => 7

          text " "

          draw_address invoice.customer.billing_vcard
        end
      end

      bounding_box [cm2pt(6.4), cm2pt(9.6)], :width => cm2pt(5) do
        draw_account_detail(account.bank, sender, print_payment_for)
        draw_account(account)
        draw_amount(invoice.balance.currency_round)
      end

      font_size 10 do
        character_spacing 1.1 do
          draw_text esr9_reference(invoice, account), :at => [cm2pt(12.7), cm2pt(6.8)]
        end
      end

      bounding_box [cm2pt(12.7), cm2pt(5.5)], :width => cm2pt(7.5) do
        draw_address(invoice.customer.billing_vcard)
      end

      # ESR-Reference
      if ::Rails.root.join('data/ocrb10.ttf').exist?
        ocr_font = ::Rails.root.join('data/ocrb10.ttf')
      else
        ocr_font = "Helvetica"
        ::Rails.logger.warn("No ocrb10.ttf found for ESR reference in #{::Rails.root.join('data')}!")
      end

      font ocr_font, :size => 11 do
        character_spacing 0.5 do
          draw_text esr9(invoice, account), :at => [cm2pt(6.7), cm2pt(1.7)]
        end
      end
    end

    def to_pdf(invoice, params = {})
      bounding_box [1.cm, bounds.top], :width => bounds.width do
        title(invoice)

        # Head info
        bounding_box [0, bounds.top - 2.4.cm], :width => 7.cm do
          biller(invoice)
        end

        bounding_box [0, bounds.top - 8.cm], :width => 7.cm do
          referrer(invoice) if invoice.referrer
          treatment(invoice)
        end

        bounding_box [12.cm, bounds.top - 3.5.cm], :width => 7.cm do
          billing_address(invoice)
        end

        bounding_box [12.cm, bounds.top - 8.cm], :width => 7.cm do
          patient(invoice)
        end

        # Invoice balance
        bounding_box [0, bounds.top - 13.cm], :width => 7.cm do
          balance(invoice)
        end
      end

      # VESR form
      draw_esr(invoice, invoice.biller.esr_account, invoice.biller, invoice.biller.print_payment_for?)

      render
    end
  end
end
