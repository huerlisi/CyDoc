# -*- encoding : utf-8 -*-
class AddDrugAccounts < ActiveRecord::Migration
  def self.up
    Accounting::Account.new(:code => '1210', :title => 'Lager Medikamente').save unless Accounting::Account.find_by_code('1210')
    Accounting::Account.new(:code => '4000', :title => 'Aufwand Medikamente').save unless Accounting::Account.find_by_code('4000')
  end

  def self.down
  end
end
