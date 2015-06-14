class Import
	include Utilities
	attr_reader :log
	def initialize
		@log = ActiveSupport::Logger.new('log/rake/import.log')
	end

	def write_to_log message,output_to_screen = false
		if output_to_screen then print message+"\n" end
		@log.info message+"\n"
	end

	def companies
		start_time = Time.now
		write_to_log "Task started at #{start_time}"


		require 'csv'    
		filename = 'props/companies.csv'
		CSV.foreach(filename, :headers => true) do |row|
			yahoo_symbol =  row['yahoo_symbol']
			company = Company.find_by yahoo_symbol: yahoo_symbol
			if ( company == nil)
				write_to_log "Creating company #{row.company_name}",true
				Company.create!(row.to_hash)
			else
				write_to_log "Company already exists",true
			end
		end
	end

	def quotes
		companies = Company.active
		companies.each do |company|
			write_to_log "Starting fetch for : #{company.company_name}",true
			# fetch company data
			remote_url = 'http://chartapi.finance.yahoo.com/instrument/1.0/'+company.yahoo_symbol+'/chartdata;type=quote;range=1m/json/'
			write_to_log "Starting data processing for : #{company.company_name}",true
			quotes = getJson remote_url,true
			#end company data

			# import quotes
			unless quotes== false
				write_to_log "Starting data insertion into db for : #{company.company_name}",true
				_quotes quotes,company
			end
		end

	end

	def historical_intraday_data

		companies = Company.active
		companies.each do |company|
			write_to_log "Starting for : #{company.company_name}",true
			url = "http://www.google.com/finance/getprices?q="+company.symbol+"&x=NSE&i=60&p=15d&f=d,c,o,h,l,v"
			write_to_log "Starting data processing for : #{company.company_name}",true
			data = csv_to_json_remote_stub url
			data = replace_time_increments_with_time data
			write_to_log "Starting data insertion into db  for : #{company.company_name}",true
			save_data_stub data,company
		end	
	end	

	private
		def save_data_stub data,company
			data.each do |date,date_group|
				quote_count = Quote.where(" company_id = ? AND quote_type = ? AND DATE(quote_date) = ? ",company.id, Quote.quote_types[:minute]  ,date ).count
				unless quote_count == date_group.count
					save_data date_group,company
				end
			end
			
		end
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
					write_to_log "saving for  and date #{row['Date']} "
					quote.save
				else
					#do nothing
				end
			end					
		end

		def replace_time_increments_with_time data
			return_data = Hash.new
			marker = nil
			data.each do |row|
				if is_number?(row['date'])
					row['timestamp'] = marker + (row['date'].to_f * 60)
				else
					 marker = row['date'].scan(/\d+/).first.to_f
					 row['timestamp'] = marker
				end
				row['date'] = Time.at(row['timestamp']).to_date
				if return_data[row['date']] == nil
					return_data[row['date']] = []
				end
				return_data[row['date']] << row
			end
			return_data
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
						write_to_log "saving for #{company.id} and date #{series['Date']} "
						quote.save
					else
						write_to_log "quote already exists for #{company.id} and date #{series['Date']}"
						#quote already exists, do nothing
					end
					
				end
			end
		end
end