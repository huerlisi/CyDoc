# -*- encoding : utf-8 -*-
module AccountsHelper
  include ActionView::Helpers::NumberHelper
  
  def currency_fmt(value)
    number_with_precision(value, :precision => 2, :separator => '.', :delimiter => "'")
  end
end
