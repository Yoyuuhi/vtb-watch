# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require File.expand_path(File.dirname(__FILE__) + "/environment")
set :output, '/var/www/vtb-watch/log/crontab.log'
set :environment, 'production'
env :SHELL, "/var/www/vtb-watch/bin"
env :PATH, ENV['PATH']
job_type :rake, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

# 一日毎にチャンネル情報更新
every 1.day, at: '4:30 am' do
  command 'cd /var/www/vtb-watch; RAILS_ENV=production bundle exec rake database:update_channel'
end

# 一時間毎に動画情報更新
every :hour do
  command 'cd /var/www/vtb-watch; RAILS_ENV=production bundle exec rake database:update_video'
end

# 30分毎に生放送時間情報更新
every 30.minute do
  command 'cd /var/www/vtb-watch; RAILS_ENV=production bundle exec rake database:update_liveSchedule'
end