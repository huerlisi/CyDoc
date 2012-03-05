module Covercard
  class Patient
    
    def self.find(value)
      return nil unless value && value.length == 19
      
      vcard = Vcard.new(:family_name => 'Simpson', 
                        :given_name => 'Homer', 
                        :street_address => 'Evergreen Terrace 742',
                        :postal_code => '9373',
                        :region => 'Springfield')
      Patient.new(:vcard => vcard, :billing_vcard => vcard, :birth_date => Date.today, :sex => 'm')
    end

    def self.clean_code(value)
      value[0..18]
    end

    attr_accessor :vcard, :birth_date, :sex, :only_year_of_birth, :billing_vcard, :vcard

    def initialize(args)
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end
end