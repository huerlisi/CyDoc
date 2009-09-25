module Praxidata
  class FinMahnungen < Base
    set_table_name "TFinMahnungen"
    set_primary_key "IDMahnung"

    belongs_to :debitor, :class_name => 'FinDebitoren', :foreign_key => 'inDebitorenID'
  end
  
  # shStufe: 1 => 1. Mahnung, 4 => Inkasso

  def status
    case shStufe
      when 1: "reminded"
      when 2: "2xreminded"
      when 3: "3xreminded"
      when 4: "encashment"
    end
  end

  def stufe
    case shStufe
      when 1: "1. Mahnung"
      when 2: "2. Mahnung"
      when 3: "3. Mahnung"
      when 4: "Inkasso"
    end
  end
end
