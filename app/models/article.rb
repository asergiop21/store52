class Article < ActiveRecord::Base

  include PgSearch

  has_attached_file :image, styles: {medium: '200x200>', small: '100x100' , thumb:'48x48>'}
  #  has_paper_trail

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


=begin  pg_search_scope :con_nombre_barcode,
    :against => [[:barcode, 'A'], [:name, 'B'], [:code_supplier, 'C']],
    #:against => [:name],
    :using => {
      :tsearch => {
     #   :prefix => true,
        :normalization => 5
      },
      trigram:    {threshold:  0.25},
    },
     :order_within_rank => "name  ASC"
#    :ranked_by => ":tsearch"
#
#
=end
=begin 
  pg_search_scope :con_nombre_barcode,
    :against => [:name, :barcode, :code_supplier],
    :using => {
              :tsearch => {
                        :prefix => true,
                        :normalization => 5 ,
                       :dictionary  => 'spanish',
      }

      trigram:    {threshold:  0.25},
    },
    :order_within_rank => "name  Desc"
#    :ranked_by => ":trigram + (0.25 * :trigram)"
=end

  #con_index_tsv

  pg_search_scope :con_nombre_barcode,
    :against => [:name, :barcode, :code_supplier],
    :using => {
      :tsearch => {
        tsvector_column: "tsv",
        :dictionary  => 'spanish',
        #:threshold => 0.1,
        # :any_word => true,
        :prefix => true,
        :normalization => 0
      }
    },
    :order_within_rank => "name  ASC"
    #         :ranked_by => ":tsearch"

    #  scope :con_nombre_barcode, ->(nombre){where("articles.name ILIKE ? or barcode ILIKE ? or code_supplier ILIKE ?","%#{nombre}%", "#{nombre}%", "#{nombre}%").order(:name)}
    scope :con_nombre, ->(nombre){joins(:supplier).where("articles.name ILIKE ?", "%#{nombre}%") }
    scope :con_id, ->(id){ where('id = ?', "#{id}")}
    #        scope :con_nombre_barcode, ->(name){where("similarity(name,?) > 0.30", name).select('name, price_total, barcode, supplier_id').order('name')}

    has_many :orders
    has_many :stocks
    has_many :deadlines
    belongs_to :category
    belongs_to :supplier

    accepts_nested_attributes_for :deadlines, :allow_destroy => true 

    validates :name, presence: true, length: { minimum: 3}, on: [:new, :create]
    validates :price_cost, numericality: true, presence: true
    validates :price_total, numericality: true, presence: true
    validates :percentaje, numericality: true

    delegate :name, to: :supplier, prefix: true, allow_nil: true

    def self.quantity_order(id)
      id.each do |b|
        stock_current = Article.find(b.article_id).quantity
        quantity = b.quantity
        stock_current = 0 if stock_current.nil?
        stock = stock_current - quantity
        Article.find_by_id(b.article_id).update_attribute(:quantity, stock)
      end
    end

    def lab
      [name]
    end

    def label
      [barcode, name,supplier.try(:name),"$  #{price_total}"].compact.join ' | '
    end
    def as_json options = nil
      default_options = { only: [:id, :price_total, :quantity, :price_cost, :allow_negative, :barcode, :iva], methods: [:label] }
      super default_options.merge(options || {})
    end
    def to_s
      name
    end

    def self.current_due_date
      @articles = Deadline.where(due_date: (Time.now.midnight)..(Time.now.midnight + 15.day)).order(due_date: :asc)
    end

    def self.import(file)
      insert_count = 0
      not_insert_count = 0
      others = {}
      proccesed = 0  
      #CSV.foreach('/home/sergio/Escritorio/arti.csv', headers: true, :encoding => 'ISO-8859-1') do |row|
      spreadsheet = open_spreadsheet(file)
      #spreadsheet =  Roo::Spreadsheet.open(file, extension: :xls)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[ header, spreadsheet.row(i)].transpose]
        #CSV.foreach(file.path, headers: true, :encoding => 'ISO-8859-1') do |row|

        supplier = Supplier.where(name: row["supplier_name"] ).first_or_create
        row["supplier_id"] = supplier.id 
        row['code_supplier']  = row['code_supplier'].gsub('/\s+/','_')
        row['code_supplier'] = row['code_supplier'].gsub('/\t+/','_')
        row['code_supplier'] = row['code_supplier'].gsub(' ','')



        article = Article.where(code_supplier: row["code_supplier"], supplier_id: row["supplier_id"]).first_or_initialize

        #article = find_by_articles_code_supplier(row["articles_code_supplier"]) 

        @article = article
        @quantity = row["quantity"]
        if (@quantity == "  " || @quantity == nil)
          row["quantity"] = 0		
        end

        if (row["price_cost"] == "" || row["price_cost"] == nil)
          row["price_cost"] = 0 
        end
        row['price_cost'] = row['price_cost'].gsub(',','.')
        row['price_total'] = row['price_total'].gsub(',','.')
        row['percentaje'] = row['percentaje'].gsub(',','.')

          @article.attributes = row.to_hash.slice('name', 'price_cost', 'code_supplier', 'price_total', 'percentaje', 'supplier_id', 'barcode')
        #@article.attributes = row.to_hash.slice(*row.to_hash.keys)
        proccesed += 1
        if @article.save 
          insert_count += 1
        else
          not_insert_count += 1 
          others[row["code_supplier"]] = row["name"]
        end
        @q = [proccesed, insert_count, not_insert_count, others]
      end
      @q
    end

    def self.open_spreadsheet(file)

      case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, csv_options: {col_sep: ";", encoding: Encoding::ISO_8859_1})
      when ".xls" then Roo::Excel.open(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Tipo de archivo desconocido: #{file.original_filename}"
      end
    end
end
