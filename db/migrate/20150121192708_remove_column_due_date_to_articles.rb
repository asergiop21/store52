class RemoveColumnDueDateToArticles < ActiveRecord::Migration[5.2]
  def change
     remove_column :articles, :due_date 
  end
end
