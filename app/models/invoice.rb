class Invoice < ActiveRecord::Base

  has_many :orders, dependent: :destroy
  has_many :account_records
  belongs_to :customer
  belongs_to :user

  accepts_nested_attributes_for :orders, :reject_if => lambda {|a| a[:article_id].blank?}

  scope :by_created_at, lambda {|from, to| where("created_at::date >= ? and created_at::date <= ? ", from, to).order("created_at asc")}
  delegate :name,   to: :customer, prefix: true, allow_nil: true
  delegate :hello,   to: :customer, prefix: true, allow_nil: true

  after_create :create_accounting_record_2
  after_create :create_current_account_2
  after_update :update_current_account
  after_update :update_accounting_record

#  def customer
    #Customer.find_or_create_by(id: 10)
#  end

  def self.find_by_filters(filters)

    q = Invoice.all
    q = by_created_at((filters[:from].to_date), (filters[:to].to_date)) if filters[:from].present? or filters[:to].present?
    q
  end

  def self.total
    @invoices = Invoice.where("created_at::date = ?", Date.today).sum(:price_total)
  end

  def self.subtotal(invoice)
    sum = 0
    @invoices = invoice
    @invoices.each { |a| sum += a.price_total.to_f}
    sum
  end
  def self.caja_diaria
    @invoices = Invoice.where("created_at::date = ?", Date.today)
  end

  def create_accounting_record_2
    @a = User.current.id
    @record = AccountingRecord.create(detail: "Remito  #{id} " , credit: price_total, invoice_id: id, user_id: User.current.id)
  end

  private

  def create_current_account_2
    @record_account = CurrentAccount.create(detail: "Remito  #{id} " , credit: price_total, customer_id: customer_id, invoice_id: id )

  end

  def update_accounting_record

    @account_record = AccountingRecord.find_by(invoice_id: self.id)
    @account_record.update_column(:credit, self.price_total)

  end
  def update_current_account

    @current_account = CurrentAccount.find_by(invoice_id: self.id)
    @current_account.update_column(:credit, self.price_total)

  end

  def self.update_items id

    @invoice = Invoice.find (id)

    @order = @invoice.orders

    @price_invoice_total = 0
    @order.each do |product|

      @article = Article.find(product.article_id)
      @price_unit = @article['price_total'].to_f
      @price_total = (@price_unit  - (@price_unit * (product.discount)/100)) * product.quantity

      product.update_attributes!(price_unit: @price_unit, price_total: @price_total)
      @price_invoice_total += @price_total
    end
    @invoice.update_attributes!( price_total: @price_invoice_total)
    @invoice
  end

end
