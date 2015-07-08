class StockPerformance
	attr_reader :number,:stock,:number_till_interval,:stock_till_interval,:verb,:adjective
	def initialize(date,companies)
		@date = date
		@companies = companies
		setup()
	end

	def setup
		@number = 0
		@stock = nil
		@number_till_interval = 0
		@stock_till_interval = nil
	end	
	def set_performing_till_interval performing_quote,day_quote,company
		if (towards_performing(performing_quote[@performance_key],day_quote.open_price)) then
			# the the increase
			percentage_change = percentage_change( day_quote.open_price,performing_quote[@performance_key] )
			#if stock is best performing save it
			if strictly_towards_performing( percentage_change,@number_till_interval )
				@number_till_interval = percentage_change
				@stock_till_interval  = company
			end
		end
	end

	def set_performing performing_quote,day_quote,company
		if @stock_till_interval != nil && (company.id == @stock_till_interval.id)
			# the price has appreciated , over the high of 10:30
			if ( strictly_towards_performing(day_quote[@performance_key],performing_quote[@performance_key]) )
				# now calculate percentage rise
				percentage_change = percentage_change (performing_quote[@performance_key],day_quote[@performance_key])
					@number = percentage_change
					@stock  = company
			# no price appreciation , after being the best performing till interval
			else
				# do something here
				#print "failure::#{company.company_name}\n"
				@number = 0
				@stock = Company.new
				@stock.company_name = 'Stock did now appreciate'
			end						
		end
	end
	
	def get_consumables company,remote = false
		to_be_returned = {}
		if remote
			data = YahooQuotes.get(company)
			#print data.to_json
			#throw Exception.new()
			to_be_returned['day_quote'] = data.day_quote
			to_be_returned['performing_quote'] = get_performing_quote_remote(data)
		else
			# the minute quote which has the highest high till the interval
			to_be_returned['performing_quote'] = get_performing_quote Quote.quote_types[:minute],@date.quote_date,company.id
			# day quote
			to_be_returned['day_quote'] 	  = Quote.get_by_date @date.quote_date,company.id
		end
		to_be_returned
	end

	def run remote = false,day_wise = true
		@companies.each do |company|
			consumable = get_consumables(company,remote)
			performing_quote = consumable['performing_quote']
			day_quote		 = consumable['day_quote']
			# if ony both are found
			if (performing_quote != nil && day_quote != nil) then
				# price has appreciated over open
				set_performing_till_interval(performing_quote,day_quote,company)
				# stock is best performing
				if day_wise
					set_performing(performing_quote,day_quote,company)
				end
			end # if ony both are found
		end # end company loop
		self
	end

	def to_print
		unless @stock_till_interval == nil 
			print "The #{@adjective} performing stock for interval #{@date.quote_date} is #{@stock_till_interval.company_name} #{@verb} is #{@number_till_interval}\n"
			unless @stock == nil
				print "The stock permormance #{@date.quote_date} is #{@stock.company_name} #{@verb} is #{@number}\n\n"
			end
		else
		 	print "NA\n"
		end
	end

	def notify
		if stock_till_interval == nil
			print " not sending"
		else
			print "sending"
			AlertMailer.notify(self).deliver_now
		end
	end

end