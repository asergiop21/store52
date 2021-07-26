class AddColumnAllowNegativeToArticles < ActiveRecord::Migration[5.2]
  def change
  
      add_column :articles, :allow_negative, :boolean, default: false
      add_column :articles, :minimum_stock, :decimal, precision: 8, scale: 2
      add_column :articles, :quantity_package, :decimal, precision: 8, scale: 2
  
  
  end
end
