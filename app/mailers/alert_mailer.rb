class AlertMailer < ApplicationMailer
	def notify
		email = 'kallarakkal@hotmail.com'
		mail(to:email,subject: 'Welcome ' )
	end
end
