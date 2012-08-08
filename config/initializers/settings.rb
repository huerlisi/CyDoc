Settings.defaults = {
  'invoices.payment_period'              => 30.days,
  'invoices.grace_period'                => 0.days,
  'invoices.balance_account_code'        => '1100',
  'invoices.profit_account_code'         => '3200',
  'invoices.extra_earnings_account_code' => '8000',
  'invoices.reminders.1.fee'             => 0.0,
  'invoices.reminders.1.payment_period'  => 20.days,
  'invoices.reminders.1.grace_period'    => 30.days,
  'invoices.reminders.2.fee'             => 10.0,
  'invoices.reminders.2.payment_period'  => 10.days,
  'invoices.reminders.2.grace_period'    => 30.days,
  'invoices.reminders.3.fee'             => 10.0,
  'invoices.reminders.3.payment_period'  => 10.days,
  'invoices.reminders.3.grace_period'    => 30.days,
  'invoices.reminders.4.fee'             => 0.0,
  'invoices.reminders.4.payment_period'  => 0.days,
  'invoices.reminders.4.grace_period'    => 30.days,

  'validation.medical_case_present'      => true,
  'validation.tarmed'                    => true,

  'patients.sex'                         => 'M',

  'printing.cups'                        => false,

  'modules.recalls'                      => true,

  'modules.drugs'                        => true,

  'modules.returned_invoices'            => true,

  'modules.hozr'                         => false,
  'cases.invoice_grace_period'           => 2.days,

  'modules.covercard'                    => false,
  'modules.covercard.host'               => '127.0.0.1',
  'modules.covercard.port'               => 5016
}
