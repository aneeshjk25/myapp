namespace :import do
	desc "Import data"
	task :historical_daily_quote => :environment do
		quotes = Quote.active
		quotes.each do |quote|
			print quote.company.company_name
		end
	end

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
end