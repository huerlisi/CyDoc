class AddScaleToItemPriceAmounts < ActiveRecord::Migration
  def up
    change_column :item_prices, :amount, :decimal, :scale => 2, :precision => 5
  end
end
