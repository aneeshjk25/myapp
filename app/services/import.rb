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

		companies = Company.active
		companies.each do |company|
			@log.info "Starting for : #{company.company_name}\n"
			print "Starting for : #{company.company_name}\n"
			url = "http://www.google.com/finance/getprices?q="+company.symbol+"&x=NSE&i=60&p=15d&f=d,c,o,h,l,v"
			data = csv_to_json_remote_stub url
			data = replace_time_increments_with_time data
			save_data data,company
		end	
		
		

	end	

	private

		def save_data data,company
			data.each do |row|
				quote = Quote.find_by("quote_timestamp = ? AND company_id = ? ",Time.at(row['timestamp']).to_datetime,company.id)
				if quote == nil
					quote = Quote.new()
					quote.company_id 	= company.id
					quote.quote_date 	= row['date']
					quote.low_price 	= row['low']
					quote.high_price 	= row['high']
					quote.open_price 	= row['open']
					quote.close_price 	= row['close']
					quote.volume 		= row['volume']
					quote.quote_timestamp 		= Time.at(row['timestamp']).to_datetime
					quote.quote_type    = :minute
					@log.info "saving for  and date #{row['Date']} "
					quote.save
				else
					#do nothing
				end
			end					
		end

		def replace_time_increments_with_time data
			return_data = []
			marker = nil
			data.each do |row|
				if is_number?(row['date'])
					row['timestamp'] = marker + (row['date'].to_f * 60)
				else
					 marker = row['date'].scan(/\d+/).first.to_f
					 row['timestamp'] = marker
				end
				row['date'] = Time.at(row['timestamp']).to_date
			end
			data
		end
		def _quotes collection_of_quotes,company
			unless collection_of_quotes['series'] == nil
				collection_of_quotes['series'].each do |series|
					quote = Quote.find_by("quote_date = '?' AND company_id = ? AND quote_type = '?' ",series['Date'],company.id,Quote.quote_types[:daily])
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