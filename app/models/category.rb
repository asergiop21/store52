class Category < ActiveRecord::Base

  has_many :articles

  def self.total 
    
    
#    Category.select( Order.where(article_id: Article.select(:id).where(category_id: Category.ids) ).sum(:price_total), :id, :name).group('categories.id', 'categories.name')
    
#    Category.pluck( Order.where(article_id: Article.select(:id).where(category_id: Category.ids) ).sum(:price_total), :id, :name).group('categories.id', 'categories.name')

    Category.joins('Left Outer Join articles on articles.category_id = categories.id Left outer Join Orders on orders.article_id = articles.id').order(:name).group('categories.id', 'categories.name').select('categories.id', 'categories.name', 'sum(orders.price_total) as price_total') 
    
    #Category.left_outer_join(:articles, :orders).order(:name).group('categories.id', 'categories.name').sum('orders.price_total')
  end


  def self.total_con_fecha(date) 
    Category.joins(articles: :orders).where('orders.created_at::date >= ? and orders.created_at::date <= ?', date[:from].to_date, date[:to].to_date ).order(:name).group(:category_id, 'categories.name').sum('orders.price_total')
    
  end




end
