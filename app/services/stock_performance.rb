class StockPerformance
	attr_reader :number,:stock,:number_till_interval,:stock_till_interval
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

	def run
		@companies.each do |company|
			# the minute quote which has the highest high till the interval
			performing_quote = Quote.top Quote.quote_types[:minute],@date.quote_date,company.id
			# day quote
			day_quote 	  = Quote.get_by_date @date.quote_date,company.id

			# if ony both are found
			if (performing_quote != nil && day_quote != nil) then

				# price has appreciated over open
				if (towards_performing(performing_quote[@performance_key],day_quote.open_price)) then
					# the the increase
					percentage_change = percentage_change( day_quote.open_price,performing_quote[@performance_key] )
					#if stock is best performing save it
					if strictly_towards_performing( percentage_change,@number_till_interval )
						@number_till_interval = percentage_change
						@stock_till_interval  = company
					end
				end

				# stock is best performing
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
						print "failure::"
						@number = 0
						@stock = Object.new
						@stock.company_name = 'NA'
					end						
				end

			end # if ony both are found
	
		end # end company loop
		self
	end

	def to_print
		unless @stock_till_interval == nil 
			print "The #{@adjective} performing stock for interval #{@date.quote_date} is #{@stock_till_interval.company_name} #{@verb} is #{@number_till_interval}\n"
			print "The stock permormance #{@date.quote_date} is #{@stock.company_name} #{@verb} is #{@number}\n\n"
		else
		 	print "NA\n"
		end
	end

end