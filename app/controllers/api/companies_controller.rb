class Api::CompaniesController < Api::BaseController
	
	def bounce
		data = getJson params[:url]
		render json: data
	end

	def toggle_status
		symbol  = params[:symbol]
		company = Company.find_by yahoo_symbol: symbol
		logger.debug " #{params[:status]}"
		if params[:status] == 'active'
			logger.debug " in active"
			company.active!
		else
			logger.debug " in in-active"
			company.inactive!
		end
		render plain: "status set to #{company.status}"
	end

	def intraday_data
		symbol = params[:symbol]
		data = {}
		if params[:date]
			company = Company.find_by yahoo_symbol: params[:symbol]
			json = Quote.get_minute_quotes(params[:date],company.id)
			data['meta'] = {}
			data['meta']['Company-Name'] = company.company_name
			data['series'] = Quote.to_yahoo(json)
		else
			remote_url = "http://chartapi.finance.yahoo.com/instrument/1.0/#{symbol}/chartdata;type=quote;range=1d/json"
			data = getJson remote_url,true
		end
		
		render json: data
	end

	def cammarilla_data
		symbol  = params[:symbol]
		company = Company.find_by yahoo_symbol: symbol
		quotes = company.quotes.order('quote_date DESC').find_by('quote_date < ? AND quote_type = ?',Date.today,Quote.quote_types[:daily])
		render json: quotes
	end

	def get_for_dropdown
		companies = Company.get_for_dropdown(params[:search])
		render json: companies
	end

end
