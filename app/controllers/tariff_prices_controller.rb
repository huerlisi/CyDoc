class TariffPricesController < AuthorizedController
  def copy
    @tariff_price = resource.copy

    @tariff_price.valid_from = Date.today
    @tariff_price.valid_to = nil

    render 'edit'
  end
end
