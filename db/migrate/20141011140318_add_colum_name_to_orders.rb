class AddColumNameToOrders < ActiveRecord::Migration[5.2]
  def up
    add_column :orders, :name, :string
  end

  def down
    remove_column :orders, :name
  end

end
