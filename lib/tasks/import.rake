namespace :import do
	
	desc "Import company from csv file"
	task :companies => :environment do
		import = Import.new
		import.companies
	end

	desc "Import daily quotes for company"
	task :quotes => :environment do
		import = Import.new
		import.quotes
	end

	desc "Historical intraday data"
	task :hid => :environment do
		import = Import.new
		import.historical_intraday_data
	end

	desc "Set Average price of each quote.Average Price (Added later)is average of all four price in a quote 
	Use this script to set average price of all quote irrespective of type in db"
	task :task_name => :environment do
		import = Import.new
		import.set_average_price
	end
end