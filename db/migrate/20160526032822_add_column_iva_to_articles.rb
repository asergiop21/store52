class AddColumnIvaToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :iva, :decimal, precision: 4, scale: 2
  
  end
end
