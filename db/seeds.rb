# -*- encoding : utf-8 -*-

# General Seeds
# =============
HonorificPrefix.create!([
  {:sex => 1, :position => 1, :name => 'Herr'},
  {:sex => 1, :position => 2, :name => 'Herr Dr.'},
  {:sex => 1, :position => 3, :name => 'Herr Dr. med.'},
  {:sex => 1, :position => 4, :name => 'Herr Prof.'},
  {:sex => 2, :position => 1, :name => 'Frau'},
  {:sex => 2, :position => 2, :name => 'Frau Dr.'},
  {:sex => 2, :position => 3, :name => 'Frau Dr. med.'},
  {:sex => 2, :position => 4, :name => 'Frau Prof.'}
])

VatClass.create!([
  {:code => "excluded", :rate => 0.0, :valid_from => '2001-01-01'},
  {:code => "reduced", :rate => 2.4, :valid_from => '2001-01-01'},
  {:code => "full", :rate => 7.6, :valid_from => '2001-01-01'}
])

# Authorization
# =============
Role::NAMES.each do |name|
  Role.create!(:name => name)
end

# Account Types
# =============
current_assets, capital_assets, outside_capital, equity_capital, costs, earnings =
AccountType.create!([
  {:name => "current_assets", :title => "Umlaufvermögen"},
  {:name => "capital_assets", :title => "Anlagevermögen"},
  {:name => "outside_capital", :title => "Fremdkapital"},
  {:name => "equity_capital", :title => "Eigenkapital"},
  {:name => "costs", :title => "Aufwand"},
  {:name => "earnings", :title => "Ertrag"},
])
