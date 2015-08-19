class Analytics 
	require 'color'
	include Utilities
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

	# print the day report from databsae
	def self.day_report_local
		companies = Company.active
		date = Quote.new
		date.quote_date  = '2015-08-19'
		best_performance = BestPerformance.new(date,companies)
		best_performance.run(false,true).to_print()
		worst_performance = WorstPerformance.new(date,companies)
		worst_performance.run(false,true).to_print()
	end

	# email the day report
	def self.find_performer
		if ( Time.zone.now.hour == 5 && Time.zone.now.min < 10 )
			find_performer_notify	
		end
	end

	def self.find_performer_notify
		companies = Company.active
		date = Quote.new
		date.quote_date  = Date.today
		best_performance = BestPerformance.new(date,companies)
		best_performance.run(true,false).notify()
		worst_performance = WorstPerformance.new(date,companies)
		worst_performance.run(true,false).notify()
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
	def self.test_strategy
		# get all active companies
		companies = Company.active
		# get all distinct dates, for which quote date day wise is set
		dates 	  = Quote.get_distinct_dates
		counters = {}
		counters['misses'] 		 = 0
		counters['partial_hits'] = 0
		counters['hits'] 		 = 0
		counters['total'] 		 = dates.count
		# for every day
		dates.each do |date|
			strategy2(date,companies,counters)
		end
		print " Partial hits = #{counters['partial_hits']} "
		print " misses = #{counters['misses']} "
		print " hits   = #{counters['hits']} "
		print " total  = #{counters['total']}"
	end

	# strategy 1 
	#  Find perforim till interval
	#  hedge on both woth strict stoploss and profit
	def self.strategy1 date,companies,counters
		# fetch the performers
		best_performance = BestPerformance.new(date,companies).run()
		worst_performance = WorstPerformance.new(date,companies).run()
		profits = []

		if best_performance.profit then profits << best_performance.profit end
		if worst_performance.profit then profits << worst_performance.profit end

		if profits.length == 0 
			counters['misses'] = counters['misses'] + 1
			print Color.red('*')
		elsif profits.length == 1
			counters['partial_hits'] = counters['partial_hits'] + 1
			print Color.yellow('*')
		else
			counters['hits'] = counters['hits'] + 1
			print Color.green('*')
		end
	end

	def self.strategy2 date,companies,counters
		best_performance = BestPerformance.new(date,companies).run()
		worst_performance = WorstPerformance.new(date,companies).run()
		profits = []

		if best_performance.profit == false && best_performance.investment_reap != nil 
		 	profits << best_performance.profit 
		end
		if worst_performance.profit == false && worst_performance.investment_reap != nil 
		 	profits << worst_performance.profit 
		end

		if profits.length == 0 
			counters['misses'] = counters['misses'] + 1
			print Color.red('*')
		elsif profits.length == 1
			counters['partial_hits'] = counters['partial_hits'] + 1
			print Color.yellow('*')
		else
			counters['hits'] = counters['hits'] + 1
			print Color.green('*')
		end
	end
end