env :PATH, ENV['PATH']
set :environment, 'production'
set :output, "#{path}/log/cron.log"
every :day, :at => '17:00' do
  rake "thing:notify_thing"
end
