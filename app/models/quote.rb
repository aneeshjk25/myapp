class Quote < BaseModel
	belongs_to :company
	enum status: [:active,:inactive]
	enum quote_type: [:na,:minute,:hourly,:daily,:monthly]
	@time_condition = "( DATE_PART('hour',quote_timestamp) <  ? OR ( DATE_PART('hour',quote_timestamp) = ? AND  DATE_PART('minute',quote_timestamp)  <= ? ) )"
	# this is comment
	def self.top quote_type,date,company_id
		hour = 5
		minute = 0
		Quote.order('high_price DESC').
		find_by("quote_type = '?' AND  quote_date = ? AND company_id = ? AND  #{@time_condition}",quote_type,date,company_id,hour,hour,minute)
	end

	def self.bottom quote_type,date,company_id
		hour = 5
		minute = 0
		Quote.order('low_price ASC').find_by("quote_type = '?' AND  quote_date = ? AND company_id = ? AND #{@time_condition} ",quote_type,date,company_id,hour,hour,minute)
	end

	def self.day_top date,company_id
		Quote.order('high_price DESC').find_by("quote_type = '?' AND  quote_date = ? AND company_id = ? ",Quote.quote_types[:daily],date,company_id)
	end

	def self.get_distinct_dates
		Quote.order('quote_date DESC').select(:quote_date).where(quote_type: Quote.quote_types[:minute]).distinct
	end

	def self.get_by_date date,company_id
		Quote.find_by(quote_date: date,company_id: company_id,quote_type: Quote.quote_types[:daily])
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