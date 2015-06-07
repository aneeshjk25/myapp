class Import
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
			@log.info "Statting for : #{company.company_name}\n"
			print "Statting for : #{company.company_name}\n"
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

  # function expect url which responds with jsonp data
  # it appends the name 'callback' to url and return json string
  # passing true returns hash object
	def getJson url, parse = false
	  	require 'net/http'
		require 'json'
		url = url+'?callback=callback'
		uri = URI.parse(url)
		jsonp = Net::HTTP.get(uri)
		jsonp.gsub!(/^.*callback\(/, '') # removes the comment and callback function from the start of the string
		hash = jsonp.gsub!(/\)$/, '') # removes the end of the callback function
		#jsonp.gsub!(/(\w+):/, '"\1":')
		if parse
			begin
				hash = JSON.parse(jsonp)
			rescue Exception => e
				hash = false
				@log.debug "JSON parse failed for "+url
			end
		end
		hash
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
						quote.save
					else
						#quote already exists, do nothing
					end
					
				end
			end
		end
end