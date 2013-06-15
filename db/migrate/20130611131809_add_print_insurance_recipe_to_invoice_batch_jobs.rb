class AddPrintInsuranceRecipeToInvoiceBatchJobs < ActiveRecord::Migration
  def change
    add_column :invoice_batch_jobs, :print_insurance_recipe, :boolean
  end
end
