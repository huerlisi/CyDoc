require 'prawn/measurement_extensions'

module Prawn
  class PatientLetter < Prawn::Document
    include ApplicationHelper
    include InvoicesHelper
    include I18nRailsHelpers

    # Helpers
    def h(s)
      return s
    end

    def set_fonts
      # Fonts
      font_path = '/usr/share/fonts/truetype/ttf-dejavu/'
      font_families.update(
        "DejaVuSans" => { :bold        => font_path + "DejaVuSans-Bold.ttf",
                          :normal      => font_path + "DejaVuSans.ttf"
        })
    end

    # Content Blocks
    def draw_address(vcard)
      text vcard.full_name
      text vcard.extended_address if vcard.extended_address.present?
      text vcard.street_address
      text vcard.postal_code + " " + vcard.locality
    end

    # Title
    def title(invoice)
      font_size 16
      text "Patientenrechnung Nr. #{invoice.id}", :style => :bold
      font_size 6.5
      text "Diese Seite ist für Ihre Unterlagen, der beilegende Rückforderungsbeleg für Ihre Krankenkasse."
    end

    # Biller / Provider
    def biller(invoice)
      font_size 6.5
      text "Rechnungssteller/Leistungserbringer:"
      font_size 8
      draw_address(invoice.biller.vcard)
      for contact in invoice.biller.vcard.contacts
        text contact.to_s
      end
      text " "
      font_size 6.5
      text "Rechnungs-Datum:"
      font_size 8
      text invoice.value_date.to_s
    end

    # Referrer
    def referrer(invoice)
      font_size 6.5
      text "Zuweisender Arzt:"
      font_size 8
      draw_address(invoice.referrer.vcard) if invoice.referrer
      text " "
      font_size 6.5
      text "Behandlung vom:"
      font_size 8
      text invoice.treatment.date_begin.to_s
    end

    # Billing Address
    def billing_address(invoice)
      font_size 10
      text invoice.patient.billing_vcard.honorific_prefix
      draw_address(invoice.patient.billing_vcard)
    end

    # Patient
    def patient(invoice)
      font_size 6.5
      text "Patient:"
      font_size 8
      draw_address(invoice.patient.vcard)
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
          booking.title + (booking.comments.present? ? "\n<font size='6.5'>#{booking.comments}</font>" : ""),
          sprintf("%0.2f CHF", booking.accounted_amount(Invoice::DEBIT_ACCOUNT))
        ]
      }
      content << [
        nil,
        invoice.due_amount.currency_round >= 0 ? I18n::translate(:open_amount, Invoice, :scope => "activerecord.attributes.invoice") : I18n::translate(:balance, Invoice, :scope => "activerecord.attributes.invoice"),
        sprintf("%0.2f CHF", invoice.due_amount.currency_round)
      ]

      table content, :width => 13.cm, :cell_style => {:inline_format => true} do
        # General
        cells.borders = []
        cells.padding = [0.5, 2, 0.5, 2]

        # With
        column(0).width = 3.cm
        column(1).width = 8.cm
        column(2).width = 2.cm

        # Alignment
        column(2).align = :right

        # Total
        row(-1).borders    = [:top]
        row(-1).font_style = :bold
      end
    end

    def vesr(invoice)
      bank_account = invoice.biller.esr_account
      bank = bank_account.bank
      amount = (invoice.state == 'booked') ? invoice.due_amount.currency_round : invoice.amount.currency_round

      font_size 8
      bounding_box [0.2.cm, 8.8.cm], :width => 5.cm do
        text bank.vcard.full_name
        text bank.vcard.postal_code + " " + bank.vcard.locality

        text " "
        text I18n::translate(:biller, :scope => "activerecord.attributes.invoice")
        text " "

        vcard = bank_account.holder.vcard
        text vcard.full_name
        text vcard.extended_address if vcard.extended_address.present?
        text vcard.street_address
        text vcard.postal_code + " " + vcard.locality

        move_down 0.7.cm
        indent 2.3.cm do
          font_size 9 do
            text bank_account.pc_id
          end
        end
      end
        
      bounding_box [0, 4.5.cm], :width => 3.5.cm do
        font_size 9 do
          text sprintf('%.0f', amount.floor), :align => :right
        end
      end

      bounding_box [4.7.cm, 4.5.cm], :width => 1.cm do
        font_size 9 do
          text sprintf('%.0f', amount * 100 % 100)
        end
      end

      bounding_box [0.2.cm, 3.2.cm], :width => 5.cm do
        text invoice.esr9_reference(bank_account)

        text " "

        vcard = invoice.patient.vcard
        text vcard.full_name
        text vcard.extended_address if vcard.extended_address.present?
        text vcard.street_address
        text vcard.postal_code + " " + vcard.locality
      end

      bounding_box [6.cm, 8.8.cm], :width => 5.cm do
        text bank.vcard.full_name
        text bank.vcard.postal_code + " " + bank.vcard.locality

        text " "
        text I18n::translate(:biller, :scope => "activerecord.attributes.invoice")
        text " "

        vcard = bank_account.holder.vcard
        text vcard.full_name
        text vcard.extended_address if vcard.extended_address.present?
        text vcard.street_address
        text vcard.postal_code + " " + vcard.locality

        move_down 0.7.cm
        indent 2.6.cm do
          font_size 9 do
            text bank_account.pc_id
          end
        end
      end

      bounding_box [6.cm, 4.5.cm], :width => 3.5.cm do
        font_size 9 do
          text sprintf('%.0f', amount.floor), :align => :right
        end
      end

      bounding_box [10.8.cm, 4.5.cm], :width => 1.cm do
        font_size 9 do
          text sprintf('%.0f', amount * 100 % 100)
        end
      end

      font_size 10 do
        draw_text invoice.esr9_reference(bank_account), :at => [12.3.cm, 5.9.cm]
      end

      bounding_box [12.1.cm, 4.5.cm], :width => 7.5.cm do
        vcard = invoice.patient.vcard
        text vcard.honorific_prefix
        text vcard.full_name
        text vcard.extended_address if vcard.extended_address.present?
        text vcard.street_address
        text vcard.postal_code + " " + vcard.locality
      end

      # ESR-Reference
      font_size 10
      font Rails.root.join('data', 'ocrb10.ttf')
      draw_text invoice.esr9(bank_account), :at => [6.1.cm, 1.cm]

      render
    end

    def to_pdf(invoice)
      # Fonts
      set_fonts

      bounding_box [1.cm, bounds.top], :width => bounds.width do
        title(invoice)

        # Head info
        bounding_box [0, bounds.top - 2.4.cm], :width => 7.cm do
          biller(invoice)
        end

        bounding_box [0, bounds.top - 8.cm], :width => 7.cm do
          referrer(invoice)
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
      vesr(invoice)
    end
  end
end
