# -*- encoding : utf-8 -*-
class Tarmed::Leistung < Tarmed::Base
  self.table_name = "LEISTUNG"
  self.primary_key = "LNR"

  has_one :text, :class_name => 'LeistungText', :conditions => "SPRACHE = 'D' AND #{self.condition_validity}", :foreign_key => 'LNR'
  has_one :digniquali, :class_name => 'LeistungDigniquali', :foreign_key => 'LNR'

  has_many :leistung_hierarchie_masters, :class_name => 'LeistungHierarchie', :foreign_key => 'LNR_SLAVE'
  has_many :leistung_hierarchie_slaves, :class_name => 'LeistungHierarchie', :foreign_key => 'LNR_MASTER'

  # Aliases to match Tarmed Invoicing
  def code
    read_attribute('LNR')
  end

  def amount_mt
    read_attribute('TP_AL')
  end

  def unit_factor_mt
    read_attribute('F_AL')
  end

  def amount_tt
    read_attribute('TP_TL')
  end

  def unit_factor_tt
    read_attribute('F_TL')
  end


  # From Hozr
  def name
    text.BEZ_255
  end

  def duration
    self.LSTGIMES_MIN || 0
    # + self.VBNB_MIN + self.BEFUND_MIN + self.ZUSATZ_MIN + self.RAUM_MIN + self.WECHSEL_MIN
  end

  def masters
    leistung_hierarchie_masters.collect { |masters| masters.master }
  end

  def slaves
    leistung_hierarchie_slaves.collect { |slaves| slaves.slave }
  end
end
