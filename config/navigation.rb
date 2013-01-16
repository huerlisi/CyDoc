# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    if user_signed_in?
      primary.item :home, t('cydoc.navigation.home'), root_path
      primary.item :patients, t('cydoc.navigation.patients'), patients_path
      if current_tenant.settings['modules.recalls']
        primary.item :recalls, t('cydoc.navigation.recalls'), recalls_path
      end

      primary.item :insurances, t('cydoc.navigation.insurances'), insurances_path
      primary.item :doctors, t('cydoc.navigation.doctors'), doctors_path
      primary.item :tariff_items, t('cydoc.navigation.service'), tariff_items_path

      if current_tenant.settings['modules.drugs']
        primary.item :drug_products, t('cydoc.navigation.drug_products'), drug_products_path
      end

      primary.item :invoices, t('cydoc.navigation.payments'), invoices_path

      if current_tenant.settings['modules.returned_invoices']
        primary.item :returned_invoices, t_model(ReturnedInvoice), returned_invoices_path
      end

      primary.item :bookkeeping, t('cydoc.navigation.accounting'), bookkeeping_index_path
      primary.item :help, t('cydoc.navigation.help'), help_path
    end
  end
end
