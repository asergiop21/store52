class AccountingRecord < ActiveRecord::Base

  scope :by_created_at, lambda {|from, to| where("created_at::date >= ? and created_at::date <= ? ", from, to).order(debit: :desc, created_at: :desc)}

  belongs_to :user
  belongs_to :invoice 



  def self.journal_user
    @accounting_record = AccountingRecord.where("created_at::date = ? and user_id =? ", Date.today, User.current.id).order(debit:  :asc,  created_at: :desc) 
  end

  def self.journal_all
    accounting_record = AccountingRecord.where("created_at::date = ? ", Date.today).order(debit:  :asc,  created_at: :desc) 
  end


  def self.filters(filters)  
    q = AccountingRecord.all  
    q = by_created_at((filters[:from].to_date), (filters[:to].to_date)) if filters[:from].present? or filters[:to].present?
    q
  end

  def self.credit(invoice)
    sum = 0
    @invoices = invoice
    @invoices.each { |a| sum += a.credit.to_f} 
    sum
  end

  def self.debit(invoice)
    sum = 0
    @invoices = invoice
    @invoices.each { |a| sum += a.debit.to_f} 
    sum
  end
  def self.total
    @invoices = AccountingRecord.where("created_at::date = ?", Date.today).sum(:debit)
  end

  def self.earnings(date=nil)
    sum = 0 
    
    @from = Date.today 
    @to = Date.today 
    @from = date[:from] if !date.nil?
    @to = date[:to] if !date.nil?

    @earnings = Article.joins(orders: :invoice).select('orders.price_total AS price_total', 'articles.price_cost AS price_cost', 'orders.quantity AS quantity', 'invoices.discount as discount').where("orders.created_at::date >= ? and orders.created_at::date <= ?", @from, @to)

    @earnings.each do |a| 
      a.quantity = 0 if a.quantity.nil?
      a.price_cost = 0 if a.price_cost.nil?
      a.price_total = 0 if a.price_total.nil?
      a.discount = 0 if a.discount.nil?
      sum += (a.price_total - (a.price_total * a.discount)/100)  - (a.price_cost * a.quantity)  
    end
    sum
  end
end
