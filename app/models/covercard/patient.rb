module Covercard
  class Patient
    def self.find(value)
      return nil unless value && value.length == 19
      
      vcard = Vcard.new(:family_name => 'Simpson', 
                        :given_name => 'Homer', 
                        :street_address => 'Evergreen Terrace 742',
                        :postal_code => '9373',
                        :locality => 'Springfield',
                        :honorific_prefix => honorific_prefix('m'))
      Patient.new(:vcard => vcard, :billing_vcard => vcard, :birth_date => Date.new(1986, 3, 25), :sex => 'm', :covercard_code => value)
    end

    def self.clean_code(value)
      value[0..18]
    end

    def self.honorific_prefix(value)
      case value
      when 'm'
        'Herr'
      when 'f'
        'Frau'
      end
    end

    attr_accessor :vcard, :birth_date, :sex, :only_year_of_birth, :billing_vcard, :vcard, :covercard_code

    def initialize(args)
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
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