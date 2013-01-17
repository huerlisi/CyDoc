# -*- encoding : utf-8 -*-
class DiagnosisByContract < Diagnosis
  # Access restrictions
  attr_accessible :code, :text

  def type
    "Contract"
  end

  def type_xml
    "by_contract"
  end
end
