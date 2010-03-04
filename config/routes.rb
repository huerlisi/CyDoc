ActionController::Routing::Routes.draw do |map|
  # Authentication
  map.logout '/logout', :controller => 'authentication_sessions', :action => 'destroy'
  map.login '/login', :controller => 'authentication_sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users

  map.resource :authentication_session

  map.resources :service_items
  
  map.resources :tariff_items, :collection => {:search => :get}, :member => {:duplicate => :post} do |tariff_item|
    tariff_item.resources :service_items, :collection => {:select => :get}
  end
  
  map.resources :medical_cases
  map.resources :diagnosis_cases
  map.resources :diagnoses
  map.resources :treatments
  map.resources :sessions do |session|
    session.resources :tariff_items
  end

  # Accounting
  map.resources :accounts, :collection => {:set_value_date_filter => :get, :statistics => :get} do |account|
    account.resources :bookings
  end
  map.resources :bookings
  
  # Billing
  map.resources :invoices, :collection => {:print_all => :post, :print_reminders_for_all => :post}, :member => {:print => :post, :print_reminder_letter => :post, :insurance_recipe => :get, :patient_letter => :get, :reminder => :get, :book => :post} do |invoice|
    invoice.resources :bookings
  end
  
  map.resources :esr_bookings

  map.resources :insurances

  map.resources :doctors

  map.resources :patients, :member => {:show_tab => :get, :localities_for_postal_code => :post, :postal_codes_for_locality => :post, :print_label => :post, :label => :get, :print_full_label => :post, :full_label => :get} do |patient|
    patient.resources :phone_numbers
    patient.resources :tariff_items, :member => {:assign => :post}
    patient.resources :invoices

    patient.resources :insurance_policies
    
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

  # Medindex
  # ========
  map.resources :drugs, :member => {:create_tariff_item => :put}
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
