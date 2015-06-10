module Utilities
  # function expect url which responds with jsonp data
  # it appends the name 'callback' to url and return json string
  # passing true returns hash object
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

	def _get url
		require 'net/http'
		require 'json'
		uri = URI.parse(url)
		response = Net::HTTP.get(uri)
	end

end