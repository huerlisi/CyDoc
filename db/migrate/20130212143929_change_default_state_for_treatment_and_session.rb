class ChangeDefaultStateForTreatmentAndSession < ActiveRecord::Migration
  def up
    ActiveRecord::Migration.change_column_default :sessions, :state, :active
    Session.where(:state => 'open').update_all(:state => 'active')

    ActiveRecord::Migration.change_column_default :treatments, :state, :active
    Treatment.where(:state => 'open').update_all(:state => 'active')
  end
end
