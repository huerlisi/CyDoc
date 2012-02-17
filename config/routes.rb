ActionController::Routing::Routes.draw do |map|
  # Root
  map.root :controller => "welcome"

  # I18n
  map.filter 'locale'

  # Authentication
  map.logout '/logout', :controller => 'authentication_sessions', :action => 'destroy'
  map.login '/login', :controller => 'authentication_sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users
  map.resource :authentication_session

  # People
  map.resources :vcards do |vcard|
    vcard.resources :phone_numbers
  end
  map.resources :phone_numbers

  # Billing
  map.resources :invoices, :collection => {:print_all => :post}, :member => {:print => :post, :print_reminder_letter => :post, :insurance_recipe => :get, :patient_letter => :get, :reminder_letter => :get, :reactivate => :post} do |invoice|
    invoice.resources :bookings
  end
  map.resources :invoice_batch_jobs, :member => {:reprint => :post}
  map.resources :reminder_batch_jobs, :member => {:reprint => :post}
  
  map.resources :esr_bookings

  map.resources :insurances

  map.resources :doctors do |doctor|
    doctor.resources :phone_numbers
  end

  map.resources :patients, :member => {:show_tab => :get, :localities_for_postal_code => :post, :postal_codes_for_locality => :post, :print_label => :post, :label => :get, :print_full_label => :post, :full_label => :get} do |patient|
    patient.resources :phone_numbers
    patient.resources :tariff_items, :member => {:assign => :post}
    patient.resources :invoices

    patient.resources :insurance_policies
    
    patient.resources :recalls, :member => {:obey => :post}
    patient.resources :appointments, :member => {:obey => :post, :accept => :post}
    patient.resources :sessions do |session|
      session.resources :tariff_items
      session.resources :service_records, :collection => {:select => :get}
    end
    patient.resources :treatments do |treatment|
      treatment.resources :invoices
      treatment.resources :diagnoses
      treatment.resources :medical_cases, :member => {:assign => :post}
      treatment.resources :sessions do |session|
        session.resources :tariff_items, :collection => {:search => :get}, :member => {:assign => :post}
      end
    end
  end

  # Recalls
  map.resources :recalls, :member => {:obey => :post, :prepare => :post, :send_notice => :put}

  # Treatments
  map.resources :medical_cases
  map.resources :diagnosis_cases
  map.resources :diagnoses
  map.resources :treatments, :collection => {:create_all => :get}
  map.resources :sessions do |session|
    session.resources :tariff_items
  end

  # Tariff
  map.resources :service_items

  map.resources :tariff_items, :collection => {:search => :get}, :member => {:duplicate => :post} do |tariff_item|
    tariff_item.resources :service_items, :collection => {:select => :get}
  end

  map.resources :drug_products, :member => {:create_tariff_item => :put} do |drug_product|
    drug_product.resources :drug_articles, :shallow => true
  end

  # Accounting
  map.resources :accounts, :collection => {:set_value_date_filter => :get, :statistics => :get}, :member => {:print => :post} do |account|
    account.resources :bookings
  end
  map.resources :bookings, :collection => {:list_csv => :get}

  # Billing
  map.resources :invoices, :collection => {:print_all => :post, :print_reminders_for_all => :post}, :member => {:print => :post, :print_reminder_letter => :post, :insurance_recipe => :get, :patient_letter => :get, :reminder => :get, :reactivate => :post} do |invoice|
    invoice.resources :bookings
  end
  map.resources :invoice_batch_jobs, :member => {:reprint => :post}

  map.resources :returned_invoices,
    :collection => {:print_request_document => :post, :request_document => :get},
    :member => {:reactivate => :post, :write_off => :post, :queue_request => :post}

  map.resources :esr_files
  map.resources :esr_bookings

  # Attachments
  map.resources :attachments, :member => {:download => :get}

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
