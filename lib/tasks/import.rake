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
end