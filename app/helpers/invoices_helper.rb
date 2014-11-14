# -*- encoding : utf-8 -*-
module InvoicesHelper
  def ean_zsr(doctor)
    [doctor.ean_party.presence, doctor.zsr.presence].compact.join(" / ")
  end

  def tax_points_mt(invoice, tariff_type)
    return nil if invoice.amount_mt(tariff_type) == 0.0

    tax_points = invoice.tax_points_mt(tariff_type)
    "(" + sprintf("%0.2f", tax_points) + ")"
  end

  def tax_points_tt(invoice, tariff_type)
    return nil if invoice.amount_tt(tariff_type) == 0.0

    tax_points = invoice.tax_points_tt(tariff_type)
    "(" + sprintf("%0.2f", tax_points) + ")"
  end

  def tax_points(invoice, tariff_type)
    return nil if invoice.amount(tariff_type) == 0.0

    tax_points = invoice.tax_points(tariff_type)
    "(" + sprintf("%0.2f", tax_points) + ")"
  end
end
