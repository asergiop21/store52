class AddBrandIdToarticles < ActiveRecord::Migration[5.2]
  def self.up
    add_column :articles, :brand_id, :integer
  end

  def self.down
    remove_column :articles, :brand_id
  end
end
