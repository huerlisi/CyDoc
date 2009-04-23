module Praxistar
  class AdressenPersonal < Base
    set_table_name "Adressen_Personal"
    set_primary_key "ID_Personal"

    def self.int_class
      Employee
    end

    def self.clean
      super
      super(User)
    end

    def self.import_record(a)
      vcard = Vcards::Vcard.new(
          :locality => a.tx_Ort,
  #        :fax_number => a.tx_Prax_Fax,
  #        :phone_number => a.tx_Prax_Telefon1,
          :postal_code => a.tx_PLZ,
          :street_address => a.tx_Strasse,
          :family_name => a.tx_Name,
          :given_name => a.tx_Vorname
      )
      vcard.save!
      
      # User
      # TODO: Password needs to be at least 6 chars!
      user = User.new(
          :login => a.tx_User,
          :password => a.tx_Kennwort,
          :password_confirmation => a.tx_Kennwort,
          :name => [a.tx_Vorname, a.tx_Name].select{|f| !f.blank?}.join(' '),
          # TODO: don't hardcode domain
          :email => a.tx_User + '@zytolabor.ch'
        )
      user.save!
      if a.tf_Aktiv?
        user.register!
        user.activate!
      end

      # Employee
      int_record = int_class.new({
        :vcard => vcard,
        :user => user,
        :active => a.tf_Aktiv?,
        :born_on => a.dt_Geburtsdatum
      })
      
      return int_record
    end
  end
end
