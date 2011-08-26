module InvoicesHelper
  def ean_zsr(doctor)
    [doctor.ean_party.presence, doctor.zsr.presence].compact.join(" / ")
  end

  def tax_points_mt(invoice, tariff_type)
    amount = invoice.amount_mt(tariff_type)
    if amount.currency_round == 0.0
      return nil
    else
      tax_points = amount / 0.89
      return "(" + sprintf("%0.2f", tax_points) + ")"
    end
  end

  def tax_points_tt(invoice, tariff_type)
    amount = invoice.amount_tt(tariff_type)
    if amount.currency_round == 0.0
      return nil
    else
      tax_points = amount / 0.89
      return "(" + sprintf("%0.2f", tax_points) + ")"
    end
  end

  def tax_points(invoice, tariff_type)
    amount = invoice.amount(tariff_type)
    if amount.currency_round == 0.0
      return nil
    else
      tax_points = amount / 0.89
      return "(" + sprintf("%0.2f", tax_points) + ")"
    end
  end
end
