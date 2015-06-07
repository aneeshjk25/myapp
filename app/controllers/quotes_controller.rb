class QuotesController < ApplicationController
	def import
		companies = Company.active
		# companies = Company.find([1,10])
		logger.debug "\n**Company : #{companies.count}\n"
		companies.each do |company|
			logger.debug "Company : #{company.company_name}\n"

			# fetch company data
			remote_url = 'http://chartapi.finance.yahoo.com/instrument/1.0/'+company.yahoo_symbol+'/chartdata;type=quote;range=1m/json/'
			quotes = getJson remote_url,true
			#end company data

			# import quotes
			unless quotes== false
				_import quotes,company
			end
		end

		#render json: companies
		render nothing: true
	end

	private
		def _import collection_of_quotes,company
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
