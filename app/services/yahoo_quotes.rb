class YahooQuotes 
	include Utilities
	attr_reader :quotes,:day_quote,:top,:bottom
	@@quote_collection = {}
	def initialize(company)
		remote_url = 'http://chartapi.finance.yahoo.com/instrument/1.0/'+company.yahoo_symbol+'/chartdata;type=quote;range=1d/json/'
		@data = getJson(remote_url,true)
		@quotes = extract_till_interval(@data['series'])
		@day_quote = @quotes[0]
	end

	def self.get company
		unless @@quote_collection[company.id] == nil
			yahoo_quote = @@quote_collection[company.id]
		else
			yahoo_quote = self.new(company)
			@@quote_collection[company.id] = yahoo_quote
		end
		return yahoo_quote
	end

	def extract_till_interval data
		hour = 4
		minute = 30
		result_set = []
		top = 0 
		bottom = 9999999
		data.each do |q|
			quote_timestamp = Time.at(q['Timestamp']).utc
			if(quote_timestamp.hour < hour || (quote_timestamp.hour == hour && quote_timestamp.min <= minute)) then
				quote = Quote.new
				quote.quote_timestamp = quote_timestamp
				quote.low_price 	= q['low']
				quote.high_price 	= q['high']
				quote.open_price 	= q['open']
				quote.close_price 	= q['close']

				if quote.high_price > top
					@top = quote
					top = quote.high_price
				end

				if quote.low_price < bottom
					@bottom = quote
					bottom  = quote.low_price
				end

				result_set << quote
			end	
		end
		return result_set
	end

end