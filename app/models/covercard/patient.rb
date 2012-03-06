module Covercard
  class Patient
    def self.find(value)
      return nil unless value && value.length == 19
      
      vcard = Vcard.new(:family_name => 'Simpson', 
                        :given_name => 'Homer', 
                        :street_address => 'Evergreen Terrace 742',
                        :postal_code => '9373',
                        :locality => 'Springfield',
                        :honorific_prefix => honorific_prefix('M'))
      Patient.new(:vcard => vcard, :billing_vcard => vcard, :birth_date => Date.new(1986, 3, 25), :sex => 'M', :covercard_code => value)
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

    attr_accessor :vcard, :birth_date, :sex, :only_year_of_birth, :billing_vcard, :vcard, :covercard_code

    def initialize(args)
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    def to_param
      covercard_code
    end

    def update(patient)
      updated_attributes = {}

      [:birth_date, :sex, :only_year_of_birth, :covercard_code].each do |attr|
        value = patient.send(attr)
        new_value = self.send(attr)

        unless value.eql?(new_value)
          patient.send("#{attr}=", new_value)
          updated_attributes[attr] = value  
        end
      end

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