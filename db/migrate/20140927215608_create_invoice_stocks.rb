class CreateInvoiceStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_stocks do |t|
      t.string :name

      t.timestamps
    end
  end
end
