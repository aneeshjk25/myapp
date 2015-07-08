class AlertMailer < ApplicationMailer
	default from: "aneesh.jose.kallarakkal@gmail.com"
	def notify quote_data
		@performer = quote_data
		logger.info " #{@performer.inspect}"
		email = 'kallarakkal@hotmail.com'
		mail(to:email,subject: @performer.verb)
	end
end
