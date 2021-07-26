class AddColumnCategoryIdToArticles < ActiveRecord::Migration[5.2]
  def self.up

    add_column :articles, :category_id, :integer, default: 1
  
  end

  def self.down

    remove_column :articles, :category_id
  
  end
end
