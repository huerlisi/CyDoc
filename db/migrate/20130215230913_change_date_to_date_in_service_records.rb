class ChangeDateToDateInServiceRecords < ActiveRecord::Migration
  def up
    change_column :service_records, :date, :date
  end

  def down
    change_column :service_records, :date, :datetime
  end
end
