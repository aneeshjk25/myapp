class FrontendController < ApplicationController
  def index
  end
  def send_email
  	result = AlertMailer.notify().deliver_now()
  	logger.info "hi #{result}"
  	render nothing: true
  end
end
