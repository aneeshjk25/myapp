class Api::BaseController < ApplicationController
	def index
		objects = controller_name.classify.constantize.all
		render json: objects
	end
	def create
		object = controller_name.classify.constantize.new(model_params())
		if object.save 
			render json: object
		else
			render json: object.errors
		end
	end


end