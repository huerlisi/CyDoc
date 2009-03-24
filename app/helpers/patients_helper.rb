# Based on redMine code
module PatientsHelper
  def patient_tabs(patient)
    tabs = [{:name => 'overview', :partial => 'patients/show', :label => patient.to_s},
            {:name => 'history', :partial => 'patients/medical_history', :label => 'Krankengeschichte'},
            {:name => 'services', :partial => 'patients/service_list', :label => 'Leistungen'},
            {:name => 'invoices', :partial => 'patients/invoice_tab', :label => 'Rechnungen'},
            ]
    # TODO check authorization, have a look at redmine
  end
end
