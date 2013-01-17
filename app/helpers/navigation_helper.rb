# -*- encoding : utf-8 -*-
module NavigationHelper
  # Navigation
  def navigation_section(section_title, items = {}, image = "#{title}.png")
    items = items.map {|title, item|
      item = {:controller => item} if item.is_a?(Symbol)
      {:title => title, :url => item}
    }

    render :partial => 'shared/navigation_section', :locals => {:section_title => section_title, :items => items, :image => image}
  end

  def invoice_navigation
    items = {
      :payment_overview => :invoices,
      :reminder_list    => {:controller => 'invoices', :tab => 'overdue'},
      :open_cases       => {:controller => 'invoices', :tab => 'open'},
      :invoice_batch_job => invoice_batch_jobs_path,
      :reminder_batch_job => reminder_batch_jobs_path
    }

    items[:create_treatments] = create_all_treatments_path# if current_doctor.settings['modules.hozr']

    items
  end

  def master_data_navigation
    items = {
              :show_doctors => :doctors,
              :show_insurances => :insurances,
              :show_tariff_items => :tariff_items,
              :show_drug_products => :drug_products,
            }

    items
  end

  def accounting_navigation
    items = {
              :show_accounts => :accounts,
#              :show_debtors => account_path(Account.find_by_code(current_doctor.settings['invoices.balance_account_code']))
            }

    items
  end

  def patient_navigation
    items = {
      :create      => {:controller => 'patients', :action => 'new'},
      :search       => :patients,
    }

    items
  end
end
