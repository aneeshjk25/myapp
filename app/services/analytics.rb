class Analytics 

	def percentage_rise amount,rise_amount
			price_jump = rise_amount - amount
			percentage_rise = price_jump/amount*100.0
	end	

	def self.day_report
		companies = Company.active
		date = Quote.new
		date.quote_date  = Date.today
		best_performance = BestPerformance.new(date,companies)
		best_performance.run(true,false).to_print()
		worst_performance = WorstPerformance.new(date,companies)
		worst_performance.run(true,false).to_print()

	end

	def self.find_performer
		if ( Time.now.hour == 0 && Time.now.minute == 33 )
			companies = Company.active
			date = Quote.new
			date.quote_date  = Date.today
			best_performance = BestPerformance.new(date,companies)
			best_performance.run(true,false).notify()
			worst_performance = WorstPerformance.new(date,companies)
			worst_performance.run(true,false).notify()
		end
	end
	
	def self.cumulative_report
		# get all active companies
		companies = Company.active
		# get all distinct dates, for which quote date day wise is set
		dates 	  = Quote.get_distinct_dates

		# for every day
		dates.each do |date|
			best_performance = BestPerformance.new(date,companies)
			best_performance.run().to_print()
			worst_performance = WorstPerformance.new(date,companies)
			worst_performance.run().to_print()
			print "*********************************************************************************************\n"
		end
	end
	def bull_report

		# get all active companies
		companies = Company.active
		# get all distinct dates, for which quote date day wise is set
		dates 	  = Quote.get_distinct_dates

		# for every day
		dates.each do |date|
			best_performing_number = 0    				# rise over highest interval,till the end of date
			best_performing_stock  = nil 				# best performing stock, at the end of the day
			best_performing_number_till_interval = 0	# best performing rise till interval
			best_performing_stock_till_interval = nil 	# best performing stock till interval

			#for every company
			companies.each do |company|
				# the minute quote which has the highest high till the interval
				highest_quote = Quote.top Quote.quote_types[:minute],date.quote_date,company.id
				# day quote
				day_quote 	  = Quote.get_by_date date.quote_date,company.id

				# if ony both are found
				if highest_quote != nil && day_quote != nil

					# price has appreciated over open
					if highest_quote.high_price >= day_quote.open_price
						# the the increase
						percentage_rise = percentage_rise day_quote.open_price,highest_quote.high_price
						#if stock is best performing save it
						if percentage_rise > best_performing_number_till_interval 
							best_performing_number_till_interval = percentage_rise
							best_performing_stock_till_interval  = company
						end
					end

					# stock is best performing
					if best_performing_stock_till_interval != nil && (company.id == best_performing_stock_till_interval.id)
						# the price has appreciated , over the high of 10:30
						if ( (highest_quote.high_price < day_quote.high_price) )
							# now calculate percentage rise
							percentage_rise = percentage_rise (highest_quote.high_price,day_quote.high_price)
								best_performing_number = percentage_rise
								best_performing_stock  = company
						# no price appreciation , after being the best performing till interval
						else
							# do something here
							print "failure::"
							best_performing_number = 0
							best_performing_stock = Object.new
							best_performing_stock.company_name = 'NA'
						end						
					end

				end # if ony both are found
		
			end # end company loop
			# If a best performing stock is found till interval print it
			unless best_performing_stock_till_interval == nil 
				print "The best performing stock for interval #{date.quote_date} is #{best_performing_stock_till_interval.company_name} rise is #{best_performing_number_till_interval}\n"
				print "The stock permormance #{date.quote_date} is #{best_performing_stock.company_name} rise is #{best_performing_number}\n\n"
			 else
			 	print "NA\n"
			end
		end
	end
end