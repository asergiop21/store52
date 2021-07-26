class AddColumnRoleToUser < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :role, :string, :default => 'invitado'
  end

  def self.down
    remove_column :users, :role
  end

end
