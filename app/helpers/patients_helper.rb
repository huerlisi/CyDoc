# Based on redMine code
module PatientsHelper
  def patient_tabs(patient)
    tabs = [{:name => 'personal', :partial => 'patients/show', :label => 'Personalien'},
            {:name => 'medical_history', :partial => 'patients/medical_history', :label => 'Diagnosen'},
            {:name => 'services', :partial => 'patients/service_list', :label => 'Leistungen'},
            {:name => 'invoices', :partial => 'patients/invoice_tab', :label => 'Rechnungen'},
            ]
    # TODO check authorization, have a look at redmine
  end
end
