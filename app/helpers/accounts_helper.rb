module AccountsHelper
  def currency_fmt(value)
    sprintf("%.2f", value)
  end
end
