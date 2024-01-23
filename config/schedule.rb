# config/schedule.rb

set :environment, 'development'

every 1.hour do
  runner 'FetchUserRecordsJob.perform_async'
end

every 1.day, at: '12:00 am' do
  runner 'TabulateDailyRecordsJob.perform_async'
end
