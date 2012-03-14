require 'net/http'
require 'net/https'
require 'uri'

module Covercard
  class Patient < ActiveRecord::Base

    SERVICE_URL = 'http://covercard.hin.ch/covercard/servlet/ch.ofac.ca.covercard.CaValidationHorizontale?type=XML&ReturnType=42a&langue=1&carte='

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

      url = URI.parse(SERVICE_URL + value)
      http = Net::HTTP::Proxy('127.0.0.1', 5016)
      response = http.get_response(url)
      
      vcard = Vcard.new(:family_name => 'Simpson', 
                        :given_name => 'Homer', 
                        :street_address => 'Evergreen Terrace 742',
                        :postal_code => '9373',
                        :locality => 'Springfield',
                        :honorific_prefix => honorific_prefix('M'))

      insurance = find_insurance({:name => 'CSS Versicherung',
                                  :bsv_code => 8,
                                  :ean_party => 7601003001082})

      insurance_policy = InsurancePolicy.new(:number => '00033079540',
                                             :policy_type => 'KVG',
                                             :insurance => insurance)

      self.new(:vcard => vcard,
               :billing_vcard => vcard,
               :birth_date => Date.new(1986, 3, 25),
               :sex => 'M',
               :covercard_code => value,
               :insurance_policy => insurance_policy)
    end

    def self.find_insurance(attributes)
      insurance = Insurance.find_by_bsv_code(attributes[:bsv_code])
      insurance ||= Insurance.find_by_ean_party(attributes[:ean_party])
      insurance ||= Insurance.clever_find(attributes[:name])

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

    def update(patient)
      updated_attributes = {}
      updated_insurance_policies = {}

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

      # Insurance policy
      if patient.insurance_policies.empty?
        patient.insurance_policies << self.insurance_policy
      else
        patient.insurance_policies.each_with_index do |p, i|
          if p.policy_type && p.policy_type.eql?(self.insurance_policy.policy_type)
            [:policy_type, :insurance_id, :number].each do |attr|
              value = p.send(attr)
              new_value = self.insurance_policy.send(attr)
              updated_insurance_policies["insurance_policies_attributes_#{i}_#{attr}"] = value unless value.eql?(new_value)
              p.send("#{attr}=", new_value)
            end
          end
        end
      end

      [patient, updated_attributes, updated_insurance_policies]
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