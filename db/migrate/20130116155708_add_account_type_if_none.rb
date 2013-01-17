# -*- encoding : utf-8 -*-

class AddAccountTypeIfNone < ActiveRecord::Migration
  def up
    return unless AccountType.count == 0

    AccountType.create!([
      {:name => "current_assets", :title => "Umlaufvermögen"},
      {:name => "capital_assets", :title => "Anlagevermögen"},
      {:name => "outside_capital", :title => "Fremdkapital"},
      {:name => "equity_capital", :title => "Eigenkapital"},
      {:name => "costs", :title => "Aufwand"},
      {:name => "earnings", :title => "Ertrag"},
    ])

  end
end
