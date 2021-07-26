class AddColumnIvaToStock < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :iva, :decimal, precision: 4, scale: 2
  end
end
