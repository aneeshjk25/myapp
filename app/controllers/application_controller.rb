class ApplicationController < ActionController::Base
	require 'json'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # function expect url which responds with jsonp data
  # it appends the name 'callback' to url and return json string
  # passing true returns hash object
=begin
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
			logger.debug "JSON parse failed for "+url
		end
	end
	hash
  end
=end


  

end
