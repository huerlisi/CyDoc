# -*- encoding : utf-8 -*-
class SetDoctorIdOnRecalls < ActiveRecord::Migration
  def self.up
    # Guessing tenant
    tenant = User.find(:first, :conditions => {:object_type => 'Doctor'}).object

    Recall.find_each do |recall|
      recall.doctor = tenant
      recall.save!
    end
  end

  def self.down
  end
end
