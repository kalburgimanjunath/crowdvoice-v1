
# USE THIS FILE TO EASILY DEFINE ALL OF YOUR CRON JOBS.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
#
# ==============================================================================

# WHENEVER DOCUMENTATION
#
# Learn more: http://github.com/javan/whenever
#
# ==============================================================================

# EXECUTE WHENEVER LIKE THIS.
#
# cd cron && whenever --load-file schedule.rb -w
#
# ==============================================================================

set :output, '/tmp/cron.log'

# download imap attachments
every 5.minutes do
  command 'cd /data/crowdvoice/current && rake imod:download RAILS_ENV=production'
end

# Deliver digest mail
every 1.days, :at => '12:00 am' do
  command 'cd /data/crowdvoice/current && rake subscriptions:digest RAILS_ENV=production'
end

# Fetch RSS feed
every 8.hours do
  command 'cd /data/crowdvoice/current && rake voices:feed' 
end

# Erase unapproved contents
every 1.days, :at => '11:00 pm' do
  command 'cd /data/crowdvoice/current && rake voices:cleanup' 
end

# Fix bad thumbnails
every 1.hour do
  command 'cd /data/crowdvoice/current && rake fix_thumbnails'
end

