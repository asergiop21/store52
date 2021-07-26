class AddColumnInvoiceIdToAccoutingRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :accounting_records, :invoice_id, :integer
  end
end
