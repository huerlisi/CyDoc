xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8", :standalone => "no"

xml.request :role => "test",
                      'xmlns:invoice' => "http://www.xmlData.ch/xmlInvoice/XSD",
                      'xmlns' => "http://www.xmlData.ch/xmlInvoice/XSD",
                      'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
                      'xsi:schemaLocation' => "http://www.xmlData.ch/xmlInvoice/XSD MDInvoiceRequest_400.xsd" do

  xml.header do
    # TODO: support TG and TP
    xml.sender :ean_party => @invoice.tiers.biller.ean_party
#    xml.intermediate :ean_party => @invoice.tiers.intermediate.ean_party
#    xml.recipient :ean_party => @invoice.tiers.recipient.ean_party
  end

  xml.prolog do
    xml.generator do
      xml.software "CyDoc", :version => 100, :id => 0
    end
  end

  xml.invoice :invoice_timestamp => @invoice.date.to_time.to_i,
              :invoice_id => @invoice.id,
              :invoice_date => @invoice.date.xmlschema, # TODO: Drop timezone info
              :resend => false, # TODO: implement for mahnung etc.
              :case_id => "" do # TODO

    xml.remark @invoice.remark unless @invoice.remark.empty?

    xml.balance 'currency' => "CHF",
                'amount' => @invoice.amount,
                'amount_prepaid' => "0.00", # TODO
                'amount_due' => @invoice.amount, # TODO round
                'amount_tarmed' => @invoice.amount, # TODO only tarmed
                'unit_tarmed.mt' => @invoice.amount_mt,
                'amount_tarmed.mt' => "19.62",
                'unit_tarmed.tt' => "25.40",
                'amount_tarmed.tt' => "20.83",
                'amount_cantonal' => "0.00",
                'amount_unclassified' => "0.00",
                'amount_lab' => "38.70",
                'amount_physio' => "0.00",
                'amount_drug' => "0.00",
                'amount_migel' => "0.00",
                'amount_obligations' => @invoice.amount do # TODO restrict on obligation

      xml.vat :vat => "0.0" do
        xml.vat_rate :vat_rate => "0.0", :amount => "0.0", :vat => "0.0"
      end
    end

    xml.esr9 :participant_number => @invoice.biller.account.pc_id,
             :type => "16or27",
             :reference_number => @invoice.esr9_reference(@invoice.biller.account),
             :coding_line => @invoice.esr9(@invoice.biller.account) do
      xml.bank do
        xml.company do
          xml.companyname @invoice.biller.account.bank.full_name
          xml.postal do
            xml.street @invoice.biller.account.bank.street_address
            xml.zip @invoice.biller.account.bank.postal_code
            xml.city @invoice.biller.account.bank.locality
          end
          # Check XSD if telecom with no .phone or .fax is valid
          xml.telecom do
            xml.phone @invoice.biller.account.bank.phone_number.number if @invoice.biller.account.bank.phone_number
            xml.fax @invoice.biller.account.bank.fax_number.number if @invoice.biller.account.bank.fax_number
          end
#          xml.online do
#            xml.email @invoice.biller.account.bank.phone_number.number if @invoice.biller.account.bank.phone_number
#            xml.url @invoice.biller.account.bank.fax_number.number if @invoice.biller.account.bank.fax_number
#          end
        end
      end
    end
  end
end
