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
		Analytics.find_performer
	end

	desc " Will find the performer using yahoo quotes and alert the user using email"
	task :pfind => :environment do
		Analytics.find_performer
	end
end