# -*- encoding : utf-8 -*-
class ChangeDurationColumnsInAppointmentsToDateTime < ActiveRecord::Migration
  def self.up
    add_column :appointments, :duration_from, :datetime
    Appointment.update_all("`duration_from` = CONCAT(`date`, ' ', `from`)")
    remove_column :appointments, :from

    add_column :appointments, :duration_to, :datetime
    Appointment.update_all("`duration_to` = CONCAT(`date`, ' ', `to`)")
    remove_column :appointments, :to
  end
end
