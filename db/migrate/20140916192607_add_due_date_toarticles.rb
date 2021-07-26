class AddDueDateToarticles < ActiveRecord::Migration[5.2]
  def up
    add_column :articles, :due_date, :date
  end

  def down
    remove_column :articles, :due_date
  end
end
