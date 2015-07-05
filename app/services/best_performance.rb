class BestPerformance < StockPerformance

	def initialize date,companies
		super
		@performance_key = 'high_price'
		@adjective = "best"
		@verb = "rise"
	end

	def towards_performing from,to
		return from >= to
	end

	def strictly_towards_performing from,to
		return from > to
	end

	def percentage_change amount,rise_amount
		price_jump = rise_amount - amount
		percentage_rise = price_jump/amount*100.0
	end
end