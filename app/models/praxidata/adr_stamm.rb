module Praxidata
  class AdrStamm < Base
    set_table_name "TadrStamm"
    set_primary_key "IDStamm"

    # shStammArt: 4 => Firma, 1 => Person, 8 => Personal
  end
end
