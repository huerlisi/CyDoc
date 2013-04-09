# -*- encoding : utf-8 -*-

CyDoc::Application.routes.draw do
  # Root
  root :to => 'welcome#index'

  # I18n
  filter 'locale'

  # Authorization
  devise_for :users, :path_prefix => :devise

  # Tenant
  resources :tenants do
    collection do
      get :current
    end

    resources :attachments
  end

  resources :vcards do
    resources :phone_numbers
  end

  resources :phone_numbers
  resources :invoices do
    collection do
      post :print_all
      get :overdue, :action => :index, :overdue => true
    end
    member do
      post :print_reminder_letter
      get :insurance_recipe
      get :patient_letter
      get :reminder_letter
      post :print
      post :reactivate
    end
    resources :bookings
  end

  resources :invoice_batch_jobs do
    member do
      post :reprint
    end
  end

  resources :reminder_batch_jobs do
    member do
      post :reprint
    end
  end

  resources :insurances do
    resources :phone_numbers

    member do
      get :new_phone_number
    end
    collection do
      get :new_phone_number
    end

  end

  resources :doctors do
    resources :phone_numbers

    member do
      get :new_phone_number
    end
    collection do
      get :new_phone_number
    end
  end

  match '/patients/covercard_search/:code' => 'patients#covercard_search', :as => :covercard_search
  match '/patients/:id/covercard_update/:covercard_code' => 'patients#covercard_update', :as => :covercard_update
  resources :patients do
    collection do
      get :dunning_stopped
    end
    member do
      get :show_tab
      post :localities_for_postal_code
      post :postal_codes_for_locality
      get :label
      post :print_label
      post :print_full_label
      post :covercard_update
      get :full_label
    end
    resources :phone_numbers
    resources :tariff_items do
      member do
        post :assign
      end
    end

    resources :invoices
    resources :insurance_policies
    resources :recalls do
      member do
        post :obey
      end
    end

    resources :appointments do
      member do
        post :obey
        post :accept
      end
    end

    resources :sessions do
      resources :tariff_items
      resources :service_records do
        collection do
          get :select
        end
      end
    end

    resources :treatments do
      resources :invoices
      resources :diagnoses
      resources :medical_cases do
        member do
          post :assign
        end
      end

      resources :sessions do
        resources :tariff_items do
          collection do
            get :search
          end
          member do
            post :assign
          end
        end
      end
    end
  end

  resources :recalls do
    member do
      post :obey
      put :send_notice
      post :prepare
    end
  end

  resources :accounts

  resources :medical_cases
  resources :diagnosis_cases
  resources :diagnoses
  resources :treatments do
    resources :sessions
  end

  resources :service_items
  resources :tariff_items do
    collection do
      get :search
    end
    member do
      post :duplicate
    end
    resources :service_items do
      collection do
        get :select
      end
    end
  end

  resources :tarmed_tariff_items, :controller => "tariff_items"
  resources :drug_tariff_items, :controller => "tariff_items"
  resources :tariff_item_groups
  resources :physio_tariff_item, :controller => "tariff_items"
  resources :free_tariff_item, :controller => "tariff_items"

  resources :drug_products do
    member do
      put :create_tariff_item
    end
    resources :drug_articles
  end
  resources :drug_articles

  resources :invoices do
    collection do
      post :print_reminders_for_all
      post :print_all
    end
    member do
      post :print_reminder_letter
      get :reminder
      get :insurance_recipe
      get :patient_letter
      post :print
      post :reactivate
    end
    resources :bookings
  end

  resources :invoice_batch_jobs do
    member do
      post :reprint
    end
  end

  resources :returned_invoices do
    collection do
      post :print_request_document
      get :request_document
    end
    member do
      post :queue_request
      post :reactivate
      post :write_off
    end
  end

  resources :bookkeeping do
    collection do
      get :report, :open_invoices, :open_invoices_csv
    end
  end

  resources :attachments do
    member do
      get :download
    end
  end

  # Search
  match 'search' => 'search#index', :as => :search

  # Help
  match '/help' => 'help#index'
  match '/help(/:action)', :controller => HelpController
end
