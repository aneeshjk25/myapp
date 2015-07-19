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
end