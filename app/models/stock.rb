class Stock < ActiveRecord::Base

  belongs_to :invoice_stock
  belongs_to :article
  has_many :deadlines

  before_save :update_quantity

  #after_create :create_due_date 

  validates :quantity, presence: true
  validates :quantity, numericality: true
  
  #accepts_nested_attributes_for :deadlines

  attr_accessor :barcode




  def update_quantity
  
    @quantity_before_save = Stock.where(id: self.id)
    @article= Article.find(article_id)
    @article.quantity = 0 if @article.quantity.nil?
    quantity_new = 0 if quantity_new.nil?
    quantity_new = @article.quantity + quantity
    percentaje = @article.percentaje.to_f 
    price_cost = self.price_cost.to_f
    price_cost = ((self.price_cost.to_f * self.iva.to_f)/100) + price_cost if !self.iva.nil?
    price_total_total = ((price_cost * percentaje)/100 + price_cost) 
    
    @article.update_columns quantity: quantity_new, category_id: category_id, price_total: price_total_total, price_cost: self.price_cost.to_f, barcode: self.barcode, iva: self.iva
  end

  def create_due_date
      @create = Deadline.create(due_date: self.due_date, article_id: article_id )
  end

  def self.to_csv

    attributes = ["Nombre_Articulo", "Codigo_barra"]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |product|
      
        1.upto(product.quantity_labels) do
          row = [product.article.name, product.article.barcode]
        csv << row
      end
      end
    end
  end

end
