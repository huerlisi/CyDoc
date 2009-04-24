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
      raise SkipException unless a.tf_Aktiv?

      # Employee
      int_record = int_class.new(
        :active => a.tf_Aktiv?,
        :born_on => a.dt_Geburtsdatum
      )

      int_record.vcards.build(
          :locality => a.tx_Ort,
          :mobile_number => a.Telefon_N,
          :phone_number => a.Telefon_P,
          :postal_code => a.tx_PLZ,
          :street_address => a.tx_Strasse,
          :family_name => a.tx_Name,
          :given_name => a.tx_Vorname
      )
      
      # User
      # TODO: Password needs to be at least 6 chars!
      user = int_record.build_user(
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
      
      return int_record
    end
  end
end
