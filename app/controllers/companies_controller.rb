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
		daily_quotes = company.daily_quotes.order('quote_date DESC').find_by('quote_date < ?',Date.today)
		render json: daily_quotes
		# render json: company
	end
	def import
		require 'csv'    
		filename = 'props/companies.csv'
		CSV.foreach(filename, :headers => true) do |row|
			logger.debug "#{row.inspect}"
			yahoo_symbol =  row['yahoo_symbol']
			company = Company.find_by yahoo_symbol: yahoo_symbol
			if ( company == nil)
				  Company.create!(row.to_hash)
			else
				logger.info "Company already exists"
			end
		end
		render nothing: true
	end
end
