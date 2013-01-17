# -*- encoding : utf-8 -*-
class TariffCode < ActiveRecord::Base
  def to_s
    "#{tariff_code} - #{description}"
  end
end
