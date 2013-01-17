# -*- encoding : utf-8 -*-
class ReParentPhoneNumbersFromPatientToVcard < ActiveRecord::Migration
  def self.up
    PhoneNumber.transaction do
      PhoneNumber.find_each do |number|
        begin
          next if number.object.is_a?(Vcard)
          next unless number.object && number.object.vcard

          number.object = number.object.vcard

          number.save!
        rescue;
          puts "Failed to re-parent PhoneNumber ##{number.id}"
        end
      end
    end
  end
end
