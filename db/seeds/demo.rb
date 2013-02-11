# -*- encoding : utf-8 -*-

# Demo Seeds
# ==========
doctor = Doctor.create!(
  :vcard => Vcard.new(
    :honorific_prefix => 'Frau Dr. med.',
    :family_name => "Muster",
    :given_name => "Melanie",
    :street_address => "Zentralgasse 99",
    :postal_code => "6300",
    :locality => "Zug"
  )
)

user = User.create!(
  :login => "doctor", :password => "doctor1234", :password_confirmation => "doctor1234", :email => "cydoc-demo@cyt.ch"
)
user.object = doctor

# Accounting
bank = Bank.create!(
  :vcard => Vcard.new(
    :full_name => "General Bank",
    :street_address => "Hauptstrasse 1",
    :postal_code => "8000",
    :locality => "Zürich"
  )
)

BankAccount.create!([
  {:pc_id => "01-123456-7", :esr_id => "444444", :code => "1020", :title => "Bankkonto", :bank => bank, :holder => doctor}
])

current_assets = AccountType.find_by_name('current_assets')
capital_assets = AccountType.find_by_name('capital_assets')
earnings = AccountType.find_by_name('earnings')
costs = AccountType.find_by_name('costs')

Account.create!([
  {:code => "1000", :title => "Kasse", :account_type => current_assets},
  {:code => "1100", :title => "Debitoren", :account_type => current_assets},
  {:code => "1210", :title => "Lager Medikamente", :account_type => capital_assets},
  {:code => "3200", :title => "Dienstleistungsertrag", :account_type => earnings},
  {:code => "3900", :title => "Debitorenverlust", :account_type => costs},
  {:code => "4000", :title => "Aufwand Medikamente", :account_type => costs},
  {:code => "8000", :title => "Ausserordentlicher Ertrag", :account_type => earnings}
])
