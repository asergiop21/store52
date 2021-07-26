class AddColumnImageToArticles < ActiveRecord::Migration[5.2]
  def change
    add_attachment :articles, :image
  
  end
end
