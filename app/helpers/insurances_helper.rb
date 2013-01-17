# -*- encoding : utf-8 -*-
module InsurancesHelper
  def insurance_role_collection
    t('activerecord.attributes.insurance.role_enum').map do |key, value|
      [value, key.to_s]
    end
  end
end
