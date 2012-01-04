class SetTreatmentState < ActiveRecord::Migration
  def self.up
    Treatment.find_each do |treatment|
      treatment.update_state
    end
  end

  def self.down
  end
end
