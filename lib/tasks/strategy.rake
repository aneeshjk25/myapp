namespace :strategy do
	desc "Report"
	task :test_strategy => :environment do
		Strategy.test_strategy(ENV['strategy'])
	end
end