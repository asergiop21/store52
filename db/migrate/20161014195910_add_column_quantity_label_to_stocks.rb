class AddColumnQuantityLabelToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :quantity_labels, :integer
  end
end
