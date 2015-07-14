class TradeSerializers < ActiveModel::Serializer
	attributes :id, :company_symbol,:trade_type,:reference,:trade_transaction_type,:amount	
end