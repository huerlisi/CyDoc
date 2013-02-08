class DropUnneededDoctorFields < ActiveRecord::Migration
  def up
    remove_column :doctors, :speciality
    remove_column :doctors, :login
    remove_column :doctors, :remarks
    remove_column :doctors, :use_vesr
    remove_column :doctors, :print_payment_for
    remove_column :doctors, :imported_id
    remove_column :doctors, :code
    remove_column :doctors, :esr_account_id
  end
end
