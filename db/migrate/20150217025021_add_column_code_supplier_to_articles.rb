class AddColumnCodeSupplierToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :code_supplier, :string
  end
end
