class WorstPerformance < StockPerformance

	def initialize date,companies
		super
		@performance_key = 'low_price'
		@adjective = "worst"
		@verb = "fall"
	end

	def towards_performing from,to
		return from <= to
	end

	def strictly_towards_performing from,to
		return from < to
	end

	def percentage_change amount,fall_amount
		price_fall = fall_amount - amount
		percentage_fall = price_fall/amount*100.0
	end	

	# 
	# Prepares date for for findind if the stock did perform, and if it would have resulted in profit
	# @param date [Date] Date 
	# @param company_id [Integer] company id
	# @param price [Float] The price found during interval
	# 
	# @return [Boolean] Whether the stock would have resulted in profit
	def did_stock_perform date,company_id,price
		profit_book_price = price - price * @profit_book_percentage
		stop_loss_price   = price + price * @stop_loss_percentage
		profit_book_quote = Quote.get_worst_performer_after_interval date,company_id,profit_book_price
		stop_loss_quote   = Quote.get_best_performer_after_interval date,company_id,stop_loss_price

		return find_performance_by_profit_quote_and_loss_quote(profit_book_quote,stop_loss_quote)
 	end

	def get_performing_quote quote_type,date,company_id
		Quote.bottom quote_type,date,company_id
	end

	def get_performing_quote_remote data
		data.bottom
	end
end