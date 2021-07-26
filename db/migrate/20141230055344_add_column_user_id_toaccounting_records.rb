class AddColumnUserIdToaccountingRecords < ActiveRecord::Migration[5.2]
  def self.up
    add_column :accounting_records, :user_id, :integer
  end

  def self.down
    remove_column :accounting_records, :user_id
  end
end
