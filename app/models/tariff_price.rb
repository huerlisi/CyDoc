class TariffPrice < ItemPrice
  condition :canton
  validates :canton, inclusion: { in: SwissMatch.cantons.map(&:license_tag) }
  condition :reason
  validates :reason, inclusion: { in: Treatment::REASON_ENUM }
  condition :unit
  validates :unit, inclusion: { in: ['medical', 'technical'] }

  def to_s
    I18n.t('activerecord.models.tariff_price')
  end

  def copy
    record = self.dup
    record.tag_list = self.tag_list

    record
  end
end
