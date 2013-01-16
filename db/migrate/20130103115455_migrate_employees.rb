class LegacyEmployee < ActiveRecord::Base
  self.table_name = 'employees'
  def work_vcard
    Vcard.where(:object_id => id, :object_type => 'Employee').first
  end
end

class MigrateEmployees < ActiveRecord::Migration
  def up
    LegacyEmployee.find_each do |employee|
      Employee.create(:vcard => employee.work_vcard, :code => employee.code)
    end
  end
end
