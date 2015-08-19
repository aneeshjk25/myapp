class Strategy 
	require 'color'
	include Utilities

	# test strategy for day report in database
	def self.test_strategy strategy_name
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
			self.method(strategy_name).call(date,companies,counters)
		end
		print " Partial hits = #{counters['partial_hits']} "
		print " misses = #{counters['misses']} "
		print " hits   = #{counters['hits']} "
		print " total  = #{counters['total']}"
	end

	# strategy 1 
	#  Find perforim till interval
	#  hedge on both strict stoploss and profit
	#  green-- both in profit
	#  yello--one profit,one loss
	#  red--both loss
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


	# strategy 1 
	#  Find perforim till interval
	#  hedge on both strict stoploss and profit, do opposite of convention (sell when stock goes up and vice versa)
	#  green-- both in profit
	#  yello--one profit,one loss
	#  red--both loss
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

	# strategy 3 
	#  Find perforim till interval
	#  hedge on both strict stoploss and profit, classis
	#  
	#  green-- both in profit
	#  yello--one profit,one loss
	#  red--both loss
	def self.strategy3 date,companies,counters
		# fetch the performers
		best_performance = BestPerformance.new(date,companies).run()
		worst_performance = WorstPerformance.new(date,companies).run()

		if best_performance.number_till_interval > worst_performance.number_till_interval.abs
			selected = best_performance
			unselected = worst_performance
		else
			selected = worst_performance
			unselected = best_performance
		end

		if selected.profit == true
			counters['hits'] = counters['hits'] + 1
			print Color.green('*')
		elsif unselected.profit == true
			counters['partial_hits'] = counters['partial_hits'] + 1
			print Color.yellow('*')
		else
			counters['misses'] = counters['misses'] + 1
			print Color.red('*')
		end
			
	end
end