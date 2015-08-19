namespace :analytics do
	desc "Report"
	task :report => :environment do
		analytics = Analytics.new
		analytics.bull_report
	end

	desc "Cumulative Report"
	task :cumulative_report => :environment do
		Analytics.cumulative_report
	end

	desc "Temp"
	task :temp => :environment do
		Analytics.temp
	end

	desc "Day Report"
	task :day_report => :environment do
		Analytics.day_report
	end

	desc "Day Report Local"
	task :drl => :environment do
		Analytics.day_report_local
	end

	desc "Will find the performer using yahoo quotes and alert the user using email"
	task :drn => :environment do
		Analytics.find_performer_notify
	end

	desc "Will find the performer using yahoo quotes and alert the user using email"
	task :test_strategy => :environment do
		Analytics.test_strategy
	end

	desc " Will find the performer using yahoo quotes and alert the user using email,is called from cron and has time check"
	task :pfind => :environment do
		Analytics.find_performer
	end
end