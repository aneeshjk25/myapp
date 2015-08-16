class Quote < BaseModel
	belongs_to :company
	enum status: [:active,:inactive]
	enum quote_type: [:na,:minute,:hourly,:daily,:monthly]
	@hour = 5
	@minute = 0
	@time_condition_less_than_interval = "( DATE_PART('hour',quote_timestamp) <  ? OR ( DATE_PART('hour',quote_timestamp) = ? AND  DATE_PART('minute',quote_timestamp)  <= ? ) )"
	@time_condition_greater_than_interval = "( DATE_PART('hour',quote_timestamp) >  ? OR ( DATE_PART('hour',quote_timestamp) = ? AND  DATE_PART('minute',quote_timestamp)  > ? ) )"
	# this is comment
	def self.top quote_type,date,company_id
		Quote.order('high_price DESC').
		find_by("quote_type = '?' AND  quote_date = ? AND company_id = ? AND  #{@time_condition_less_than_interval}",quote_type,date,company_id,@hour,@hour,@minute)
	end

	def self.bottom quote_type,date,company_id
		Quote.order('low_price ASC').find_by("quote_type = '?' AND  quote_date = ? AND company_id = ? AND #{@time_condition_less_than_interval} ",quote_type,date,company_id,@hour,@hour,@minute)
	end

	def self.day_top date,company_id
		Quote.order('high_price DESC').find_by("quote_type = '?' AND  quote_date = ? AND company_id = ? ",Quote.quote_types[:daily],date,company_id)
	end

	def self.get_distinct_dates
		Quote.order('quote_date DESC').select(:quote_date).where(quote_type: Quote.quote_types[:minute]).distinct
	end

	def self.get_quote_at_interval date,company_id
		Quote.find_by("quote_type = '?' AND quote_date = ? AND company_id = ? AND ( DATE_PART('hour',quote_timestamp) =  ? AND DATE_PART('minute',quote_timestamp)  = ? ) ",Quote.quote_types[:minute],date,company_id,@hour,@minute)
	end

	# 
	# Returns the first quote after interval , greater than price
	# @param date [Date] Date for which to look
	# @param company_id [Integer] Id of company
	# @param price [Float] The appreciated or depreciated price
	# @return [Quote] The quote if found
	def self.get_best_performer_after_interval date,company_id,price
		Quote.order('quote_timestamp ASC').
		find_by("quote_type = '?' AND  quote_date = ? AND company_id = ? AND  high_price >= ? AND #{@time_condition_greater_than_interval}",Quote.quote_types[:minute],date,company_id,price,@hour,@hour,@minute)
	end

	# 
	# Returns the first quote after interval , greater than price
	# @param date [Date] Date for which to look
	# @param company_id [Integer] Id of company
	# @param price [Float] The appreciated or depreciated price
	# @return [Quote] The quote if found
	def self.get_worst_performer_after_interval date,company_id,price
		Quote.order('quote_timestamp ASC').
		find_by("quote_type = '?' AND  quote_date = ? AND company_id = ? AND  low_price <= ? AND #{@time_condition_greater_than_interval}",Quote.quote_types[:minute],date,company_id,price,@hour,@hour,@minute)
	end

	# 
	# Returns daily quote for a particular date for a particular company
	# @param date [Date] The date for which quote is required
	# @param company_id [Integer] The id of the company
	# 
	# @return [Quote] Quote object for queried date and company	
	def self.get_by_date date,company_id
		Quote.find_by(quote_date: date,company_id: company_id,quote_type: Quote.quote_types[:daily])
	end	
	
	# 
	# Returns daily quote for the previous trading day of the supplied date
	# @param date [Date] The date from which to find previous date quote
	# @param company_id [Integer] The id of the company
	# 
	# @return [Quote] Quote object for previous trading date and company		
	def self.get_previous_trading_day_quote date,company_id
		Quote.order('quote_date DESC').
				find_by("quote_date < ? AND company_id = ? AND quote_type = ? ",date,company_id,Quote.quote_types[:daily])
	end
	def self.get_minute_quotes date,company_id
		Quote.where(quote_date: date,company_id: company_id,quote_type: Quote.quote_types[:minute])
	end	
	def self.to_yahoo quotes
		data = []
		quotes.each do |quote|
			data << quote.to_yahoo
		end
		data
	end
	def to_yahoo
		data = {}
		data['Timestamp'] = quote_timestamp.to_i
		data['open']      = open_price
		data['close'] 	  = close_price
		data['high'] 	  = high_price
		data['low']		  = low_price
		return data
	end
end