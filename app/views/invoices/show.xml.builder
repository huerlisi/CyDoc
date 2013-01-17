def company_to_xml(xml, company)
  xml.company do
    xml.companyname company.vcard.full_name
    vcard_to_xml(xml, company.vcard)
  end
end

def person_to_xml(xml, person)
  opt_attrs = {}
  opt_attrs[:salutation] = person.honorific_prefix unless person.honorific_prefix.blank?
  xml.person opt_attrs do
    xml.familyname person.family_name
    xml.givenname person.given_name
    vcard_to_xml(xml, person.vcard)
  end
end

def vcard_to_xml(xml, vcard)
  xml.postal do
    xml.street vcard.street_address unless vcard.street_address.blank?
    xml.zip vcard.postal_code
    xml.city vcard.locality
  end
  unless vcard.phone_numbers.select{|number| !(number.number.blank?)}.empty?
    xml.telecom do
      xml.phone vcard.phone_number.number if (vcard.phone_number and !(vcard.phone_number.number.blank?))
      xml.fax vcard.fax_number.number if (vcard.fax_number and !(vcard.fax_number.number.blank?))
    end
  end
#          xml.online do
#            xml.email vcard.phone_number.number if vcard.phone_number
#            xml.url vcard.number if vcard.fax_number
#          end
end

# TODO: call with index
def tarmed_record_to_xml(xml, service_record, index = 1)
  # Don't hardcode ambulatory
  xml.record_tarmed service_record.text,
                    :tariff_type         => service_record.tariff_type,
                    :treatment           => "ambulatory", # TODO: no hardcoding
                    :ean_provider        => service_record.provider.ean_party,
                    :ean_responsible     => service_record.responsible.ean_party,
                    :billing_role        => "both", # TODO: check what means
                    :medical_role        => "self_employed", # TODO: check what means
                    :body_location       => "none", # TODO: implement in service_record
                    'unit.mt'            => service_record.unit_mt,
                    'unit_factor.mt'     => service_record.unit_factor_mt,
                    'scale_factor.mt'    => service_record.scale_factor_mt,
                    'external_factor.mt' => service_record.external_factor_mt,
                    'amount.mt'          => service_record.amount_mt,
                    'unit.tt'            => service_record.unit_tt,
                    'unit_factor.tt'     => service_record.unit_factor_tt,
                    'scale_factor.tt'    => service_record.scale_factor_tt,
                    'external_factor.tt' => service_record.external_factor_tt,
                    'amount.tt'          => service_record.amount_tt,
                    'amount'             => service_record.amount,
                    'vat_rate'           => service_record.vat_rate, # TODO: support in service_record creation
                    'validate'           => "true", # TODO: check what means
                    'obligation'         => service_record.obligation,
                    'record_id'          => index,
                    'number'             => 1, # TODO: check what means
                    'quantity'           => service_record.quantity,
                    'date_begin'         => service_record.date.xmlschema,
                    'code'               => service_record.code
end

def service_record_to_xml(xml, service_record)
  case service_record.tariff_type
    when "001"
      tarmed_record_to_xml(xml, service_record)
  end
end

# Main Document
# =============
xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8", :standalone => "no"

xml.request :role => "test",
                      'xmlns:invoice' => "http://www.xmlData.ch/xmlInvoice/XSD",
                      'xmlns' => "http://www.xmlData.ch/xmlInvoice/XSD",
                      'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
                      'xsi:schemaLocation' => "http://www.xmlData.ch/xmlInvoice/XSD MDInvoiceRequest_400.xsd" do

  xml.header do
    # TODO: support TG and TP
    xml.sender :ean_party => @invoice.tiers.biller.ean_party
    xml.intermediate :ean_party => @invoice.tiers.intermediate.ean_party
    xml.recipient :ean_party => (@invoice.tiers.is_a?(TiersGarant) ? "unknown" : @invoice.tiers.recipient.group_ean_party)
  end

  xml.prolog do
    xml.generator do
      xml.software "CyDoc", :version => 100, :id => 0
    end
  end

  opt_attrs = {}
  opt_attrs[:case_id] = @invoice.case_id unless @invoice.case_id.blank?
  xml.invoice :invoice_timestamp => @invoice.value_date.to_time.to_i,
              :invoice_id => @invoice.id,
              :invoice_date => @invoice.value_date.xmlschema, # TODO: Drop timezone info
              :resend => false, # TODO: implement for mahnung etc.
              *opt_attrs do # TODO: no case_id in cydoc, yet

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
             :coding_line => @invoice.esr9(@invoice.biller.account).gsub('&nbsp;', ' ') do
      xml.bank do
        company_to_xml xml, @invoice.biller.account.bank
      end
    end


    def tiers(xml)
      opt_attrs = {}
      opt_attrs[:speciality] = @invoice.biller.speciality unless @invoice.biller.speciality.blank?
      xml.biller :ean_party => @invoice.biller.ean_party, :zsr => @invoice.biller.zsr, *opt_attrs do
        person_to_xml xml, @invoice.biller
      end
      opt_attrs = {}
      opt_attrs[:speciality] = @invoice.provider.speciality unless @invoice.provider.speciality.blank?
      xml.provider :ean_party => @invoice.provider.ean_party, :zsr => @invoice.provider.zsr, *opt_attrs do
        person_to_xml xml, @invoice.provider
      end

      xml.patient :gender => @invoice.patient.sex_xml, :birthdate => @invoice.patient.birth_date.xmlschema do
        person_to_xml xml, @invoice.patient
      end
      xml.guarantor do
        # TODO: Patient not always == guarantor
        person_to_xml xml, @invoice.patient
      end

      xml.referrer do
        person_to_xml xml, @invoice.referrer
      end
    end

    # TODO: payment_period not hardcoded
    case @invoice.tiers
      when TiersGarant
        xml.tiers_garant :payment_periode => "P#{@invoice.payment_period}D" do tiers(xml) end
      when TiersPayant
        xml.tiers_payant do tiers(xml) end
    end

    xml.detail :date_begin => @invoice.date_begin.xmlschema, :date_end => @invoice.date_end.xmlschema, :canton => @invoice.treatment.canton, :service_locality => (@invoice.place_type || "practice") do
      @invoice.treatment.diagnoses.each{|diagnosis|
        xml.diagnosis :type => diagnosis.type_xml, :code => diagnosis.code
      }

      # TODO: check what case_date means
      # TODO: support more laws
      opt_attrs = {}
      opt_attrs[:patient_id] = @invoice.patient.insurance_id unless @invoice.patient.insurance_id.blank?
      case @invoice.law.name.downcase
        when 'kvg'
          xml.kvg :reason => @invoice.treatment.reason_xml, :case_date => @invoice.date_begin.xmlschema, *opt_attrs
        when 'mvg'
          xml.kvg :reason => @invoice.treatment.reason_xml, :case_date => @invoice.date_begin.xmlschema, *opt_attrs
        when 'uvg'
          xml.uvg :reason => @invoice.treatment.reason_xml, :case_date => @invoice.date_begin.xmlschema, *opt_attrs
      end

      xml.services do
        @invoice.service_records.each{|service_record|
          service_record_to_xml xml, service_record
        }
      end
    end
  end
end
