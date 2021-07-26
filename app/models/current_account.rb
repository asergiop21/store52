class CurrentAccount < ActiveRecord::Base

  belongs_to :customer
  

  def self.total(current_account)
    credit = 0
    debit = 0
    @current_account = current_account
    @current_account.each { |a| 
      credit += a.credit.to_f
      debit += a.debit.to_f
    } 
        @result = {credit: credit, debit: debit}
  end

  def self.create_accounting_record(detail, debit)
    @record = AccountingRecord.create(detail: detail , debit: debit )
  end


end
