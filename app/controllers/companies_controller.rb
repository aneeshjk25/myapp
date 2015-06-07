class CompaniesController < ApplicationController
	
	def index
		companies = Company.all
		render json: companies
	end

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
		remote_url = "http://chartapi.finance.yahoo.com/instrument/1.0/#{symbol}/chartdata;type=quote;range=1d/json"
		json = getJson remote_url,true
		render json: json
	end

	def cammarilla_data
		symbol  = params[:symbol]
		company = Company.find_by yahoo_symbol: symbol
		quotes = company.quotes.order('quote_date DESC').find_by('quote_date < ? AND quote_type = ?',Date.today,Quote.quote_types[:daily])
		render json: quotes
	end
end
