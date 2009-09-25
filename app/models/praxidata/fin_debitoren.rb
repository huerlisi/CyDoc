module Praxidata
  class FinDebitoren < Base
    set_table_name "TFinDebitoren"
    set_primary_key "IDDebitor"

    belongs_to :beleg, :class_name => 'BelBelege', :foreign_key => 'inBelegID'
    has_many :mahnungen, :class_name => 'FinMahnungen', :foreign_key => 'inDebitorenID'

    # inRate: 0 => alle
  end
end
