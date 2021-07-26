class InvoiceStock < ActiveRecord::Base
  has_many :stocks

  accepts_nested_attributes_for :stocks, :reject_if => lambda {|a| a[:article_id].blank?}

  attr_accessor :supplier_idis, :supplier_name


  def self.total
    @invoice_stock = InvoiceStock.where("created_at::date = ?", Date.today).sum(:price_total)
  end

  def to_s
    name
  end

  def self.to_csv

    attributes = %w{name}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      @all = all
      pry
      all.each do |product|
        p product
        csv << attributes.map { |attr|  product.send(attr) } 
      end
    end
  end


def name
end 



end
