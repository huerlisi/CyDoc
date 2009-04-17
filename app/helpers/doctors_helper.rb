module DoctorsHelper
  def doctor_tabs(doctor)
    tabs = [{:name => 'personal', :partial => 'doctors/show', :label => 'Personalien'},
            {:name => 'accounting', :partial => 'doctors/accounting_tab', :label => 'Konten'},
            {:name => 'printing', :partial => 'doctors/printing_tab', :label => 'Drucker Einstellungen'},
            ]
  end
end
