class LegacyDoctor < ActiveRecord::Base
  self.table_name = 'doctors'
  serialize :channels
  def vcard
    Vcard.where(:object_id => id, :object_type => 'Doctor').first
  end
  def user
    User.where(:object_id => id, :object_type => 'Doctor').first
  end
end

class PortDoctorToPerson < ActiveRecord::Migration
  def up
    add_column :people, :ean_party, :string, :limit => 13
    add_column :people, :zsr, :string, :limit => 7
    add_column :people, :channels, :text

    LegacyDoctor.find_each do |doctor|
      new_doctor = Doctor.create(
        :active => doctor.active,
        :vcard => doctor.vcard,
        :user => doctor.user,
        :ean_party => doctor.ean_party,
        :zsr => doctor.zsr,
        :channels => doctor.channels
      )

      Mailing.where(:doctor_id => doctor.id).update_all(:doctor_id => new_doctor.id)
      Case.where(:doctor_id => doctor.id).update_all(:doctor_id => new_doctor.id)
      Patient.where(:doctor_id => doctor.id).update_all(:doctor_id => new_doctor.id)
    end

    drop_table :doctors
  end
end
