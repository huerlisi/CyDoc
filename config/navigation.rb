# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'

  navigation.items do |primary|
    if user_signed_in?
      primary.item :home, t('cydoc.navigation.home'), root_path
      primary.item :patients, t('cydoc.navigation.patients'), patients_path do |entry|
        entry.item :patients_index, t_title(:index, Patient), patients_path
        if current_tenant.settings['modules.recalls']
          entry.item :recalls, t('cydoc.navigation.recalls'), recalls_path
        end
      end

      primary.item :insurances, t('cydoc.navigation.insurances'), insurances_path
      primary.item :doctors, t('cydoc.navigation.doctors'), doctors_path

      primary.item :tariff_items, t_title(:index, TariffItem), tariff_items_path do |entry|
        entry.item :traiff_items_index, t_title(:index, TariffItem), tariff_items_path
        entry.item :traiff_item_groups_index, t_title(:index, TariffItemGroup), tariff_item_groups_path

        if current_tenant.settings['modules.drugs']
          entry.item :drug_products, t_title(:index, DrugProduct), drug_products_path
        end
      end

      primary.item :invoices, t_title(:index, Invoice), invoices_path do |entry|
        entry.item :invoices_index, t_title(:index, Invoice), invoices_path

        entry.item :divider, "", :class => 'divider'

        entry.item :new_esr_file, t_title(:new, EsrFile), new_esr_file_path
        entry.item :esr_files, t_title(:index, EsrFile), esr_files_path

        entry.item :divider, "", :class => 'divider'

        if current_tenant.settings['modules.returned_invoices']
          entry.item :returned_invoices, t_model(ReturnedInvoice), returned_invoices_path
        end
      end

      primary.item :bookkeeping, t('cydoc.navigation.accounting'), bookkeeping_index_path
      primary.item :help, t('cydoc.navigation.help'), help_path
    end
  end
end
