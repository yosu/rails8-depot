class AddShipDateToOrder < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :ship_date, :date
  end
end
