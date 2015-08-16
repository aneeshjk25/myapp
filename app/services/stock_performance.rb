class StockPerformance
	attr_reader :number,:stock,:number_till_interval,:stock_till_interval,:verb,:adjective,:performing_quote,:profit
	attr_accessor :performing_quote
	def initialize(date,companies)
		@date = date
		@companies = companies
		setup()
	end

	def setup
		@number 				= 0
		@stock 					= nil
		@number_till_interval   = 0
		@stock_till_interval    = nil
		@quote_till_interval    = nil
		@quote_to_invest		= nil
		@performing_quote       = nil
		@number_to_invest		= 0
		@investment_reap		= nil
		@profit_book_percentage = 0.01   # 1 percent
		@stop_loss_percentage   = 0.005  # 0.5 percent
		@profit 				= false
	end	
	
	def set_performing_till_interval performing_quote,day_quote,company
		if (towards_performing(performing_quote['average_price'],day_quote.close_price)) then
			# the the increase
			percentage_change = percentage_change( day_quote.close_price,performing_quote['average_price'] )
			#if stock is best performing save it
			if strictly_towards_performing( percentage_change,@number_till_interval )
				@number_till_interval = percentage_change
				@stock_till_interval  = company
				@quote_till_interval = performing_quote
				@quote_to_invest	  = Quote.get_quote_at_interval(@date.quote_date,company.id)
				@number_to_invest	  = @quote_to_invest[@performance_key]
			end
		end
	end


	def set_performing performing_quote,purchase_price,company
		if @stock_till_interval != nil && (company.id == @stock_till_interval.id)
			# the price has appreciated , over the high of 10:30
			if ( did_stock_perform(@date.quote_date,company.id,purchase_price) )
				# now calculate percentage rise
				percentage_change = percentage_change (purchase_price,@investment_reap[@performance_key])
					@number = percentage_change
					@stock  = company
			# no price appreciation , after being the best performing till interval
			else
				# do something here
				@number = 0
				@stock = Company.new
				@stock.company_name = 'Stock did not appreciate'
			end	
		end
	end

	# 
	# The function returns if trade ended in profit by taking in quote for both profit and loss (nil is unavaialble)
	# @param profit_book_quote [Quote] The quote for profit point if reached, nil if unavailble
	# @param stop_loss_quote [Quote] The quote for loss point if reached,nil if unavailable
	# 
	# @return [Boolen] if trade would have resulted in profit
	def find_performance_by_profit_quote_and_loss_quote(profit_book_quote,stop_loss_quote)
 		# no price rise and price drop seen after interval, never possible 
		if(stop_loss_quote == nil && profit_book_quote == nil)
			@investment_reap = nil
			return false
			#throw Exception.new("Error should never happen")
		end

		# if price rise and price fall both happen
		if(stop_loss_quote != nil && profit_book_quote != nil)
			#profit point reached before loss point
			if( profit_book_quote.quote_timestamp < stop_loss_quote.quote_timestamp)
				@investment_reap = profit_book_quote
				return true
			else
				@investment_reap = stop_loss_quote
				return false
			end
		else
			#Profit quote  found 
			if(profit_book_quote == nil)
				@investment_reap = stop_loss_quote
				return false
			else
				@investment_reap = profit_book_quote
				return true
			end
		end
 	end

	# 
	# Returns a hash with the 
	# [get_consumables description]
	# @param company [Company] []
	# @param remote = false [type] [description]
	# 
	# @return [Hash] [description]	
	def get_consumables company,remote = false
		to_be_returned = {}
		if remote
			data = YahooQuotes.get(company)
			to_be_returned['performing_quote'] = get_performing_quote_remote(data)
		else
			# the minute quote which has the highest high till the interval
			to_be_returned['performing_quote'] = get_performing_quote Quote.quote_types[:minute],@date.quote_date,company.id
		end
		# day quote
		to_be_returned['day_quote'] 	  = Quote.get_previous_trading_day_quote @date.quote_date,company.id
		return to_be_returned
	end

	# 
	# Runs the perfomer to find the best or worst performer
	# @param remote = false [Boolean] Whether to fetch quotes from db or from remote(yahoo)
	# @param day_wise = true [Boolean] Whether to fetch the performer tille interval and stop or fetch its performance
	# 		till the end of the day 
	# @return self returns the object itself			
	def run remote = false,day_wise = true
		@companies.each do |company|
			consumable = get_consumables(company,remote)
			# print consumable.to_json
			# throw Exception.new("woh")
			performing_quote = consumable['performing_quote']
			day_quote		 = consumable['day_quote']
			# if ony both are found
			if (performing_quote != nil && day_quote != nil) then
				# price has appreciated over open
				set_performing_till_interval(performing_quote,day_quote,company)
				# stock is best performing
				
			end # if ony both are found
		end # end company loop
		if day_wise
			set_performing(@quote_to_invest,@number_to_invest,@stock_till_interval)
		end
		self
	end

	# 
	# Print the status of the performer i.e print the performer till interval 
	# also print performer at day end if available
	# 
	# @return void
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