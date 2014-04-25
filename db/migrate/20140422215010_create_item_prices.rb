class CreateItemPrices < ActiveRecord::Migration
  def change
    create_table :item_prices do |t|
      t.string :code
      t.decimal :amount
      t.date :valid_from
      t.date :valid_to

      t.timestamps
    end

    add_index :item_prices, :code
    add_index :item_prices, :valid_from
    add_index :item_prices, :valid_to
  end
end
