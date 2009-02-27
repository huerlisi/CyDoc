# Based on redMine code
module PatientsHelper
  def patient_tabs
    tabs = [{:name => 'info', :partial => 'patients/show', :label => 'Information'},
            {:name => 'history', :partial => 'patients/medical_history', :label => 'Krankengeschichte'},
            {:name => 'services', :partial => 'patients/service_list', :label => 'Leistungen'},
            {:name => 'invoices', :partial => 'patients/invoice_tab', :label => 'Rechnungen'},
            ]
    # TODO check authorization, have a look at redmine
  end
end
