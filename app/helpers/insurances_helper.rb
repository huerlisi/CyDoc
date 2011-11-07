module InsurancesHelper
  def insurance_role_collection
    t('activerecord.attributes.insurance.role_enum').invert
  end
end
