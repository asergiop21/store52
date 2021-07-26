class AddColumnStockIdToDeadlines < ActiveRecord::Migration[5.2]
  def change
    add_column :deadlines, :stock_id, :integer
  
  end
end
