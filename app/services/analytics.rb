class Analytics 

	def percentage_rise amount,rise_amount
			price_jump = rise_amount - amount
			percentage_rise = price_jump/amount*100.0
	end	

	# print the day report
	def self.day_report
		companies = Company.active
		date = Quote.new
		date.quote_date  = Date.today
		best_performance = BestPerformance.new(date,companies)
		best_performance.run(true,false).to_print()
		worst_performance = WorstPerformance.new(date,companies)
		worst_performance.run(true,false).to_print()

	end
	# email the day report
	def self.find_performer
		if ( Time.zone.now.hour == 5 && Time.zone.now.minute < 10 )
			companies = Company.active
			date = Quote.new
			date.quote_date  = Date.today
			best_performance = BestPerformance.new(date,companies)
			best_performance.run(true,false).notify()
			worst_performance = WorstPerformance.new(date,companies)
			worst_performance.run(true,false).notify()
		end
	end
	
	# print day report for all in database
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

	# test strategy for day report in database
	def self.test_stategy
		# get all active companies
		companies = Company.active
		# get all distinct dates, for which quote date day wise is set
		dates 	  = Quote.get_distinct_dates

		misses = 0
		clear_misses = 0
		hits = 0
		total = dates.count
		# for every day
		dates.each do |date|
			best_performance = BestPerformance.new(date,companies).run()
			worst_performance = WorstPerformance.new(date,companies).run()
			if best_performance.number_till_interval > worst_performance.number_till_interval.abs
					selection = best_performance.number_till_interval
					stock = best_performance
				else
					selection = worst_performance.number_till_interval.abs
					stock = worst_performance
			end
			if selection <= 0 
				clear_misses = clear_misses + 1
			else
				if stock.number.abs <= 0
					clear_misses = clear_misses +1
				elsif stock.number.abs >= 1.5
					hits = hits + 1
				else
					misses = misses + 1
				end
			end
			print "*"
		end
		print " clear misses = #{clear_misses} "
		print " misses = #{misses} "
		print " hits = #{hits} "
		print " total = #{total}"
	end
end