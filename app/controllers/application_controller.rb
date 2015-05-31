class ApplicationController < ActionController::Base
	require 'json'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # function expect url which responds with jsonp data
  # it appends the name 'callback' to url and return json strin
  # passing true return hash object
  def getJsonFromJsonp url, parse = false
  	require 'net/http'
	require 'json'
	url = url+'?callback=callback'
	uri = URI.parse(url)
	jsonp = Net::HTTP.get(uri)
	jsonp.gsub!(/^.*callback\(/, '') # removes the comment and callback function from the start of the string
	hash = jsonp.gsub!(/\)$/, '') # removes the end of the callback function
	#jsonp.gsub!(/(\w+):/, '"\1":')
	if parse
		hash = JSON.parse(jsonp)
	end
	hash
  end

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
		hash = JSON.parse(jsonp)
	end
	hash
  end

end
