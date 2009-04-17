module DoctorsHelper
  def doctor_tabs(doctor)
    tabs = [{:name => 'personal', :partial => 'doctors/show', :label => 'Personalien'},
            {:name => 'doctor', :partial => 'doctors/doctor_show', :label => 'Arzt Informationen'},
            {:name => 'accounting', :partial => 'doctors/accounting_tab', :label => 'Rechnungswesen'},
            {:name => 'printing', :partial => 'doctors/printing_tab', :label => 'Drucker Einstellungen'},
            ]
  end
end
