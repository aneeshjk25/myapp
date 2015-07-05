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
end