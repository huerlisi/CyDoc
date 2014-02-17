# -*- encoding : utf-8 -*-
Settings.defaults = {
  'invoices.payment_period'              => 30,
  'invoices.grace_period'                => 0,
  'invoices.balance_account_code'        => '1100',
  'invoices.profit_account_code'         => '3200',
  'invoices.extra_earnings_account_code' => '8000',
  'invoices.reminders.1.fee'             => 0.0,
  'invoices.reminders.1.payment_period'  => 20,
  'invoices.reminders.1.grace_period'    => 30,
  'invoices.reminders.2.fee'             => 10.0,
  'invoices.reminders.2.payment_period'  => 10,
  'invoices.reminders.2.grace_period'    => 30,
  'invoices.reminders.3.fee'             => 10.0,
  'invoices.reminders.3.payment_period'  => 10,
  'invoices.reminders.3.grace_period'    => 30,
  'invoices.reminders.4.fee'             => 0.0,
  'invoices.reminders.4.payment_period'  => 0,
  'invoices.reminders.4.grace_period'    => 30,
  'invoices.reminders.print_insurance_recipe' => "0",
  'invoices.print_payment_for'           => "1",

  'validation.medical_case_present'      => "1",
  'validation.tarmed'                    => "1",

  'patients.sex'                         => 'M',

  'printing.cups'                        => "0",

  'modules.recalls'                      => "1",

  'modules.drugs'                        => "1",

  'modules.returned_invoices'            => "1",

  'modules.hozr'                         => "1",
  'cases.invoice_grace_period'           => 2.days,

  'modules.covercard'                    => "0",
  'modules.covercard.host'               => '127.0.0.1',
  'modules.covercard.port'               => 5016
}
