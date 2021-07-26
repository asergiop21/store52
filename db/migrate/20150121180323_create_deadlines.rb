class CreateDeadlines < ActiveRecord::Migration[5.2]
  def change
    create_table :deadlines do |t|

      t.date :due_date
      t.references :article

      t.timestamps
    end
  end
end
