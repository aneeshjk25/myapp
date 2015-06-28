module Utilities
  # function expect url which responds with jsonp data
  # it appends the name 'callback' to url and return json string
  # passing true returns hash object
	require 'csv'
  
	def getJson url, parse = false
	  	
		url = url+'?callback=callback'
		jsonp = _get url
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

	def csv_to_json_file_stub
		filename = 'props/companies.csv'
		data = File.read(filename)
		 CSV.parse(data).to_json
	end

	def csv_to_json_remote_stub url
		response = _get url
		csv_to_json response,%w(date close high low open volume)
	end


	def csv_to_json csv,header
		json = csv_to_array_hash csv
		data = []
		json.each do |row|
			data << Hash[header.zip row]
		end
		data
	end

	def csv_to_array_hash csv_data
		data  = Array.new 
		#print CSV.parse(csv_data).class
		CSV.parse(csv_data).each_with_index do |row,index|
			if index > 6 
				data << row
			end
		end
		data
	end

	def write_to_file content,filename
		File.open(filename, "w") do |f|
			f.write content
		end
	end

	def _get url
		require 'net/http'
		require 'json'
		uri = URI.parse(url)
		response = Net::HTTP.get(uri)
	end

	def is_number?(object)
	  true if Float(object) rescue false
	end	

end