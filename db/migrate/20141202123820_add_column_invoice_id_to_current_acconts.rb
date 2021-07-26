class AddColumnInvoiceIdToCurrentAcconts < ActiveRecord::Migration[5.2]
  def change
    add_column :current_accounts, :invoice_id, :integer
  end
end
