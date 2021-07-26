class RemoveColumnDueDateToStocks < ActiveRecord::Migration[5.2]
  def change
  
      remove_column :stocks, :due_date
  
  end
end
