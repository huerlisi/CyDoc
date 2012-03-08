require 'json'

module Covercard
  class Patient < ActiveRecord::Base
    # Tableless active record
    class_inheritable_accessor :columns
    self.columns = []
   
    def self.column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end
   
    column :vcard, :string
    column :billing_vcard, :string
    column :birth_date, :date
    column :sex, :string
    column :covercard_code, :string
    column :insurance_policy, :string
    column :insurance, :string
    column :only_year_of_birth, :integer

    serialize :insurance_policy, InsurancePolicy
    serialize :vcard, Vcard
    serialize :billing_vcard, Vcard

    def self.find(value)
      return nil unless value && value.length == 19
      
      vcard = Vcard.new(:family_name => 'Simpson', 
                        :given_name => 'Homer', 
                        :street_address => 'Evergreen Terrace 742',
                        :postal_code => '9373',
                        :locality => 'Springfield',
                        :honorific_prefix => honorific_prefix('M'))

      insurance_policy = InsurancePolicy.new(:number => '00033079540',
                                             :policy_type => 'KVG')

      Patient.new(:vcard => vcard,
                  :billing_vcard => vcard,
                  :birth_date => Date.new(1986, 3, 25),
                  :sex => 'M',
                  :covercard_code => value,
                  :insurance_policy => insurance_policy,
                  :insurance => {:name => 'CSS Versicherung',
                                 :bsv_code => 8,
                                 :ean_party => 7601003001082})
    end

    def self.insurance_policy(insurance_policy_attributes, insurance_attributes)
      insurance_policy = InsurancePolicy.new(JSON.parse(insurance_policy_attributes))
      insurance = find_insurance(JSON.parse(insurance_attributes))
      insurance_policy.insurance = insurance if insurance

      insurance_policy
    end

    def self.find_insurance(attributes)
      insurance = Insurance.find_by_bsv_code(attributes['bsv_code'])
      insurance ||= Insurance.find_by_ean_party(attributes['ean_party'])
      insurance ||= Insurance.clever_find(attributes['name'])

      insurance
    end

    def self.clean_code(value)
      value[0..18]
    end

    def self.honorific_prefix(value)
      case value
      when 'M'
        'Herr'
      when 'F'
        'Frau'
      end
    end

    def to_param
      covercard_code
    end

    def update(patient)
      updated_attributes = {}

      # Common attributes
      [:birth_date, :sex, :only_year_of_birth, :covercard_code].each do |attr|
        value = patient.send(attr)
        new_value = self.send(attr)

        unless value.eql?(new_value)
          patient.send("#{attr}=", new_value)
          updated_attributes[attr] = value  
        end
      end

      # Addresses
      [:vcard, :billing_vcard].each do |v|
        vcard = patient.send(v)
        new_vcard = self.send(v)

        [:family_name, :given_name, :street_address, :postal_code, :locality, :honorific_prefix].each do |attr|
          value = vcard.send(attr)
          new_value = new_vcard.send(attr)

          unless value.eql?(new_value)
            vcard.send("#{attr}=", new_value)
            updated_attributes["#{v}_attributes_#{attr}"] = value
          end
        end
      end

      [patient, updated_attributes]
    end

    # Proxy accessors
    def name
      if vcard.nil?
        ""
      else
        vcard.full_name || ""
      end
    end
  end
end