class Analytics 

	def percentage_rise amount,rise_amount
			price_jump = rise_amount - amount
			percentage_rise = price_jump/amount*100.0
	end	

	def bull_report
		companies = Company.active
		#companies = Company.where(symbol: 'BPCl')
		dates 	  = Quote.get_distinct_dates
		count = 1
		dates.each do |date|
			best_performing_number = 0
			best_performing_stock  = nil
			best_performing_number_till_interval = 0
			best_performing_stock_till_interval = nil
			companies.each do |company|
				highest_quote = Quote.top Quote.quote_types[:minute],date.quote_date,company.id
				day_quote 	  = Quote.get_by_date date.quote_date,company.id

				if highest_quote != nil && day_quote != nil
					# price has appreciated over open
					if day_quote.open_price <= highest_quote.high_price
						#if stock is best performing save it
						percentage_rise = percentage_rise day_quote.open_price,highest_quote.high_price
						if percentage_rise > best_performing_number_till_interval 
							best_performing_number_till_interval = percentage_rise
							best_performing_stock_till_interval  = company
							#print "Putting this for  #{date.quote_date} is #{best_performing_stock_till_interval.company_name}\n"
						end
					end

					# stock is best performing
					if best_performing_stock_till_interval != nil && (company.id == best_performing_stock_till_interval.id)
						# the price has appreciated , over the high of 10:30
						if ( (highest_quote.high_price < day_quote.high_price) )
							# now calculate percentage rise
							percentage_rise = percentage_rise (highest_quote.high_price,day_quote.high_price)
							if percentage_rise > best_performing_number
								best_performing_number = percentage_rise
								best_performing_stock  = company
							end
						# no price appreciation , after being the best performing till interval
						else
							# do something here
							print "failure::"
							best_performing_number = 0
							best_performing_stock = Object.new
							best_performing_stock.company_name = 'NA'
						end						
					end

				end
		
			end # end company loop
			unless best_performing_stock_till_interval == nil 
				print "The best performing stock for interval #{date.quote_date} is #{best_performing_stock_till_interval.company_name} rise is #{best_performing_number_till_interval}\n"
				print "The stock permormance #{date.quote_date} is #{best_performing_stock.company_name} rise is #{best_performing_number}\n\n"
			 else
			 	print "NA\n"
			end
		end
	end
end