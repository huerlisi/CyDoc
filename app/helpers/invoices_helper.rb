module InvoicesHelper
  def invoice_tabs
    tabs = [
      {:name => 'overview', :partial => 'invoices/show', :label => 'Übersicht'},
      {:name => 'insurance_recipe', :partial => 'invoices/insurance_recipe', :label => 'Rückforderungsbeleg'},
      {:name => 'patient_letter', :partial => 'invoices/patient_letter', :label => 'Rechnung'}
    ]
    # TODO check authorization, have a look at redmine
  end
end
