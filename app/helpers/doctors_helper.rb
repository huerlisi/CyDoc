module DoctorsHelper
  def doctor_tabs(doctor)
    tabs = [{:name => 'overview', :partial => 'doctors/show', :label => doctor.to_s},
            {:name => 'accounting', :partial => 'doctors/accounting_tab', :label => 'Konten'},
            {:name => 'printing', :partial => 'doctors/printing_tab', :label => 'Drucker Einstellungen'},
#            {:name => 'billing', :partial => 'doctors/billing_tab', :label => 'Rechnungs Einstellungen'},
            ]
  end
end
