class Trade < ActiveRecord::Base
	belongs_to :company,:foreign_key => 'company_symbol'
	validates :company_symbol, presence: true
	validates :trade_type, presence: true
	validates :reference, presence: true
	validates :trade_transaction_type, presence: true
	validates :amount, presence: true
	validates :time_of_trade, presence: true
end
