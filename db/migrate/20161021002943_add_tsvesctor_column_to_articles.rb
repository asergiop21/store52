class AddTsvesctorColumnToArticles < ActiveRecord::Migration[5.2]
  def change
      add_column :articles, :tsv, :tsvector
      add_index :articles, :tsv, using: :gin

      execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE 
      ON articles FOR EACH ROW EXECUTE PROCEDURE  tsvector_update_trigger(
      tsv, 'pg_catalog.english', name, barcode, code_supplier);
      SQL
      now = Time.current.to_s(:db)
      update("UPDATE articles SET updated_at = '#{now}'")
  
  end
end
