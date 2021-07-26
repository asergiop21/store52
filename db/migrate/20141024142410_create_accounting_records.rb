class CreateAccountingRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :accounting_records do |t|
      t.string :detail
      t.decimal :debit, :precision => 8, :scale => 2
      t.decimal :credit, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
