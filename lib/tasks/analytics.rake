namespace :analytics do
	desc "Report"
	task :report => :environment do
		analytics = Analytics.new
		analytics.bull_report
	end
end