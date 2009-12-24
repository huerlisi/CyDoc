module AccountsHelper
  def currency_fmt(value)
    number_with_precision(value, :precision => 2, :separator => '.', :delimiter => "'")
  end
end
