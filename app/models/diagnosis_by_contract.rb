# -*- encoding : utf-8 -*-
class DiagnosisByContract < Diagnosis
  def type
    "Contract"
  end

  def type_xml
    "by_contract"
  end
end
