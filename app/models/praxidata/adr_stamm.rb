module Praxidata
  class AdrStamm < Base
    set_table_name "TadrStamm"
    set_primary_key "IDStamm"

    # shStammArt: 4 => Firma, 1 => Person, 8 => Personal
    has_one :person, :class_name => 'AdrPersonen', :foreign_key => 'inStammID'
    has_one :arzt, :class_name => 'ArzAerzte', :foreign_key => 'inStammID'
    has_one :firma, :class_name => 'AdrFirmen', :foreign_key => 'inStammID'
    has_one :personal, :class_name => 'AdrPersonal', :foreign_key => 'inStammID'
    has_one :adresse, :class_name => 'AdrAdressen', :foreign_key => 'inStammID'

    def object
      case shStammArt
        when 4: return firma
        when 8: return personal
        when 1: return person
      end
    end
  end
end
