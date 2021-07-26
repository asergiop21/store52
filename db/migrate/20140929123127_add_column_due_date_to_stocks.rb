class AddColumnDueDateToStocks < ActiveRecord::Migration[5.2]

  def up
    add_column :stocks, :due_date, :date
  end

  def down
    remove_column :stocks, :due_date
  end

end
