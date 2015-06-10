class Import
	include Utilities
	attr_reader :log
	def initialize
		@log = ActiveSupport::Logger.new('log/rake/import.log')
	end

	def companies
		start_time = Time.now
		@log.info "Task started at #{start_time}"


		require 'csv'    
		filename = 'props/companies.csv'
		CSV.foreach(filename, :headers => true) do |row|
			yahoo_symbol =  row['yahoo_symbol']
			company = Company.find_by yahoo_symbol: yahoo_symbol
			if ( company == nil)
				print "Creating company #{row.company_name}\n"
				@log.info "Creating company #{row.company_name}\n"
				Company.create!(row.to_hash)
			else
				@log.warn "Company already exists\n"
				print "Company already exists\n"
			end
		end
	end

	def quotes
		companies = Company.active
		companies.each do |company|
			@log.info "Starting for : #{company.company_name}\n"
			print "Starting for : #{company.company_name}\n"
			# fetch company data
			remote_url = 'http://chartapi.finance.yahoo.com/instrument/1.0/'+company.yahoo_symbol+'/chartdata;type=quote;range=1m/json/'
			quotes = getJson remote_url,true
			#end company data

			# import quotes
			unless quotes== false
				_quotes quotes,company
			end
		end

	end

	def historical_intraday_data
		require 'csv'
		url = "http://www.google.com/finance/getprices?q=ACC&x=NSE&i=60&p=2d&f=d,c,o,h,l"
		csv_data = _get url
		@log.info csv_data
		CSV.foreach(csv_data.rstrip) do |row|
			print "row"
		end
	end	


	

	private
		
		def _quotes collection_of_quotes,company
			unless collection_of_quotes['series'] == nil
				collection_of_quotes['series'].each do |series|
					quote = Quote.find_by("quote_date = '?' AND company_id = ? ",series['Date'],company.id)
					if quote == nil
						# save new quote
						quote = Quote.new()
						quote.company_id 	= company.id
						quote.quote_date 	= series['Date']
						quote.low_price 	= series['low']
						quote.high_price 	= series['high']
						quote.open_price 	= series['open']
						quote.close_price = series['close']
						quote.volume 		= series['volume']
						quote.quote_type   = :daily
						@log.info "saving for #{company.id} and date #{series['Date']} "
						quote.save
					else
						@log.info "quote already exists for #{company.id} and date #{series['Date']}"
						#quote already exists, do nothing
					end
					
				end
			end
		end
end